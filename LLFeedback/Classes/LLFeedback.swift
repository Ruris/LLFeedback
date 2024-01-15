//
//  LLFeedback.swift
//  LLFeedback
//
//  Created by ZHK on 2023/12/7.
//
//

import UIKit
import MessageUI
import StoreKit


/// 用户反馈
public struct LLFeedback {
    
    public enum Result {
        case email(Bool, String)
        case email(Error)
    }
    
    @Standard(defaultValue: 0, key: "_LLFeedback_LastDate")
    /// 存储最后一次询问的时间 (时间戳)
    private static var lastDate: Int
    
    @Standard(defaultValue: false, key: "_LLFeedback_Scored_01")
    /// 是否已经进行过评分
    private static var scored: Bool
    
    /// 是否自动进行流程
    private static var auto: Bool = false
    
    /// 用户上次未进行打分, 中间间隔多久再次进行询问 (默认一周)
    private static var repeatInterval: Int = 604800
    
    /// 重复询问时间间隔是否已经过期 (过期则需要重新询问)
    public static var repeatTimeout: Bool {
        return (Int(CFAbsoluteTimeGetCurrent()) - lastDate) > repeatInterval
    }
    
    /// 当前库的 bundle
    static let bundle: Bundle? = {
        let bundle = Bundle(for: LLFeedbackViewController.classForCoder())
        guard let path = bundle.path(forResource: "LLFeedback", ofType: "bundle") else {
            return nil
        }
        return Bundle(path: path)
    }()
    
    /// 应用名称 (优先读取国际化的名称, 如果都读取不到就读取 Bundle ID)
    public static var appName: String {
        Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String ??
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ??
        Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String
    }
    
    /// 启动
    /// - Parameter auto: 是否自动默认 (自动弹起询问框并进行后续逻辑判断)
    /// - Parameter interval: 用户上次未进行打分, 中间间隔多久再次进行询问 (默认为 7 天)
    public static func start(_ auto: Bool, interval: Int = 604800) {
        // 如果最后一次询问时间为默认值, 则判定为第一次启动, 重置为当前时间
        if lastDate == 0 {
            lastDate = Int(CFAbsoluteTimeGetCurrent())
        }
        Self.auto = auto
        Self.repeatInterval = interval
    }
    
    /// 重置最后一次弹框时间 (仅限测试使用)
    /// - Parameter lastDate: (最后一次弹框时间) 默认值为 1
    public static func reset(lastDate: Int = 1) {
        Self.lastDate = lastDate
        scored = false
    }
    
    /// 标记本次已经打过分了
    public static func markScored() {
        lastDate = Int(CFAbsoluteTimeGetCurrent())
        scored = true
    }
    
    /// 用户反馈界面
    /// - Returns: 视图控制器
    public static func viewController() -> UIViewController {
        LLFeedbackViewController()
    }
    
    /// 发送邮件界面
    /// - Parameters:
    ///   - recipient: 邮箱地址
    ///   - viewController: modal 起邮箱视图的控制器
    /// - Returns: 是否处理发送成功 (如果触发跳转默认为发送成功)
    @MainActor
    public static func feedback(sendTo recipient: String, modalBy viewController: UIViewController) async throws -> Bool {
        /// 如果刚询问过, 或者已经打过分了, 就不再询问了
        guard repeatTimeout, scored == false else {
            return false
        }
        /// 首先试探用户对 app 的态度
        /// 如果不满意, 就让用户进行反馈
        /// 如果还算满意, 就让用户进行打分
        let success: Bool
        if await probe(modalBy: viewController) == false {
            success = try await send(email: recipient, presentBy: viewController)
        } else {
            success = store(scoreBy: viewController)
        }
        /// 如果操作成功了, 就标记为已经打过分了
        if success {
            markScored()
        }
        return success
    }
}

extension LLFeedback {
    
    /// 发送反馈
    /// - Parameter message: 反馈信息
    public static func send(message: String) async throws {
        
    }
}

extension LLFeedback {
    
    static func LocalizedString(_ key: String, comment: String) -> String {
        guard let bundle = Self.bundle else {
            return comment
        }
        return NSLocalizedString(key, tableName: "LLFeedback", bundle: bundle, value: "", comment: comment)
    }
}

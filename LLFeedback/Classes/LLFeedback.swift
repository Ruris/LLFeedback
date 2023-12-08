//
//  LLFeedback.swift
//  LLFeedback
//
//  Created by ZHK on 2023/12/7.
//
//


/// 用户反馈
public struct LLFeedback {
    
    /// 当前库的 bundle
    static let bundle: Bundle? = {
        let bundle = Bundle(for: LLFeedbackViewController.classForCoder())
        guard let path = bundle.path(forResource: "LLFeedback", ofType: "bundle") else {
            return nil
        }
        return Bundle(path: path)
    }()
 
    public static func viewController() -> UIViewController {
        LLFeedbackViewController()
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

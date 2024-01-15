//
//  LLFeedback.Email.swift
//  LLFeedback
//
//  Created by ZHK on 2024/1/8.
//  
//

import Foundation
import MessageUI

extension LLFeedback {
    
    @MainActor
    /// 想指定邮箱发送邮件
    /// - Parameters:
    ///   - recipient: 邮箱地址
    ///   - viewController: modal 邮件界面的视图控制器
    /// - Returns: 是否发送完成
    public static func send(email recipient: String, presentBy viewController: UIViewController) async throws -> Bool {
        // 尝试调起发送邮件页面, 如果调起失败就跳转到邮件 app
        if MFMailComposeViewController.canSendMail() {
            return try await email(sendTo: recipient, presentBy: viewController)
        } else {
            try email(byApp: recipient)
            return true
        }
    }
    
    
    
    @MainActor
    /// 显示 Emali 发送界面
    /// - Parameters:
    ///   - recipient: 邮箱地址
    ///   - viewController: modal 使用的控制器
    /// - Returns: 是否发送成功
    public static func email(sendTo recipient: String, presentBy viewController: UIViewController) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            let subject = appName
            let body = "version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            let delegator = EMailComposeDelegator { success, message in
                if success {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(with: .failure(LLError(message)))
                }
            }
            let mailViewController = MFMailComposeViewController()
            mailViewController.setToRecipients([recipient])
            mailViewController.setSubject(subject)
            mailViewController.setMessageBody(body, isHTML: false)
            mailViewController.delegate = delegator
            mailViewController.mailComposeDelegate = delegator
            viewController.present(mailViewController, animated: true, completion: nil)
        }
    }
    
    @MainActor
    /// 打开邮件 app
    /// - Parameter recipient: 邮箱地址
    public static func email(byApp recipient: String) throws {
        let subject = NSLocalizedString("我的书橱", comment: "我的书橱")
        let body = "version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
        let email = "\(recipient)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: "mailto:\(email ?? "")"), UIApplication.shared.canOpenURL(url) {
            open(url: url)
        } else {
            throw LLError(NSLocalizedString("您还未设置邮箱", comment: "您还未设置邮箱"))
        }
    }
    
    @MainActor
    /// 打开 URL
    /// - Parameter url: URL
    private static func open(url: URL) {
        UIApplication.shared.open(url)
    }
}

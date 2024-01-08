//
//  EMailComposeDelegator.swift
//  LLFeedback
//
//  Created by ZHK on 2024/1/8.
//  
//

import UIKit
import MessageUI


class EMailComposeDelegator: NSObject, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    typealias Complete = (Bool, String) -> Void
    
    private var holder: EMailComposeDelegator?
    
    private let complete: Complete
    
    init(complete: @escaping Complete) {
        self.complete = complete
        super.init()
        self.holder = self
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            break
        case .failed:
            complete(false, NSLocalizedString("发送失败", comment: "发送失败"))
        case .saved:
            complete(false, NSLocalizedString("已保存到草稿", comment: "已保存到草稿"))
        case .sent:
            complete(true, NSLocalizedString("已发送", comment: "已发送"))
        @unknown default:
            complete(false, NSLocalizedString("未知错误", comment: "未知错误"))
        }
        controller.dismiss(animated: true) {
            self.holder = nil
        }
    }
}

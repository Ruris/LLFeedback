//
//  UIAlertController.swift
//  LLFeedback
//
//  Created by ZHK on 2024/1/8.
//  
//

import UIKit

extension LLFeedback {
    
    /// 判断用户的态度
    /// - Parameter viewController: modal 使用的视图控制器
    /// - Returns: 是否满意
    @MainActor
    static func probe(modalBy viewController: UIViewController) async -> Bool {
        await withCheckedContinuation { continuation in
            let aletr = UIAlertController(title: NSLocalizedString("请告诉我您的想法", comment: "请告诉我您的想法"), message: NSLocalizedString("您已经使用了一段时间了, 您对 app 的功能和交互是否满意?", comment: "您已经使用了一段时间了, 您对 app 的功能和交互是否满意?"), preferredStyle: .alert)
            aletr.addAction(UIAlertAction(title: NSLocalizedString("我要吐槽", comment: "我要吐槽"), style: .cancel, handler: { _ in
                continuation.resume(returning: false)
            }))
            aletr.addAction(UIAlertAction(title: NSLocalizedString("非常满意", comment: "非常满意"), style: .default, handler: { _ in
                continuation.resume(returning: true)
            }))
            viewController.present(aletr, animated: true)
        }
    }
}

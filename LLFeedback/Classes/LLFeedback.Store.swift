//
//  LLFeedback.Store.swift
//  LLFeedback
//
//  Created by ZHK on 2024/1/8.
//  
//

import Foundation
import StoreKit

extension LLFeedback {
    
    ///  使用 StoreKit 进行平凡
    /// - Parameter viewController: modal 弹窗的视图控制器
    public static func store(scoreBy viewController: UIViewController) -> Bool {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            return true
        } else {
            /// 因为 `SKStoreReviewController.requestReview()` 在 iOS14 已经弃用
            /// 因此在 `iOS14` 及以上版本中使用 `present` 的方式发起打分
            if #available(iOS 14, *) {
                guard let appid = Bundle.main.infoDictionary?["appid"] as? String else {
                    print("需要在 Info.plist 文件中设置 appid 字段")
                    return false
                }
                let delegator = StoreProductViewControllerDelegator()
                let storeViewController = SKStoreProductViewController()
                storeViewController.delegate = delegator
                let param = [SKStoreProductParameterITunesItemIdentifier : appid]
                storeViewController.loadProduct(withParameters: param, completionBlock: nil)
                viewController.present(storeViewController, animated: true, completion: nil)
                return true
            } else {
                SKStoreReviewController.requestReview()
                return true
            }
        }

    }
    
    /// 打开 appstore 评论打分页面
    /// - Parameter appid: appid (ITC 中的 appid)
    public static func appstore(appid: String) throws {
        let url = URL(string: "itms-apps://itunes.apple.com/gb/app/id\(appid)?action=write-review&mt=8")
        if UIApplication.shared .canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            throw "打开失败" as LLError
        }
    }
}

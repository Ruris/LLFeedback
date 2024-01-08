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
    
    public static func store(scoreBy viewController: UIViewController) {
        let url = URL(string: "itms-apps://itunes.apple.com/gb/app/id1464406562?action=write-review&mt=8")
        if UIApplication.shared .canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            } else {
                let delegator = StoreProductViewControllerDelegator()
                let storeViewController = SKStoreProductViewController()
                storeViewController.delegate = delegator
                let param = [SKStoreProductParameterITunesItemIdentifier : "1464406562"]
                storeViewController.loadProduct(withParameters: param, completionBlock: nil)
                viewController.present(storeViewController, animated: true, completion: nil)
            }
        }
    }
}

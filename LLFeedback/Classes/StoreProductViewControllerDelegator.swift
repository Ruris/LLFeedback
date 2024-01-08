//
//  StoreProductViewControllerDelegator.swift
//  LLFeedback
//
//  Created by ZHK on 2024/1/8.
//  
//

import Foundation
import StoreKit

class StoreProductViewControllerDelegator: NSObject, SKStoreProductViewControllerDelegate {
    
    private var holder: StoreProductViewControllerDelegator?
    
    override init() {
        super.init()
        holder = self
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true) {
            self.holder = nil
        }
    }
}

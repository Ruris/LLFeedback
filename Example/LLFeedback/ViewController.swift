//
//  ViewController.swift
//  LLFeedback
//
//  Created by Ruris on 12/07/2023.
//  Copyright (c) 2023 Ruris. All rights reserved.
//

import UIKit
import LLFeedback

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func modalAction(_ sender: Any) {
        present(LLFeedback.viewController(), animated: true)
    }
    
    @IBAction func pushAction(_ sender: Any) {
        navigationController?.pushViewController(LLFeedback.viewController(), animated: true)
    }
}


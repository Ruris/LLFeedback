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
    
    struct Section {
        
        let title: String
        
        let actions: [String]
    }

    @IBOutlet weak var tableView: UITableView!
    
    private let data: [Section] = [
        Section(title: "自动", actions: ["开始", "重置"]),
        Section(title: "邮箱", actions: ["发邮件"]),
        Section(title: "接口", actions: ["Push", "Modal"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LLFeedback.start(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func modalAction() {
        present(UINavigationController(rootViewController: LLFeedback.viewController()), animated: true)
    }
    
    func pushAction() {
        navigationController?.pushViewController(LLFeedback.viewController(), animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section].actions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        data[section].title
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            Task {
                try? await LLFeedback.feedback(sendTo: "", modalBy: self)
            }
        case (0, 1):
            LLFeedback.reset()
        case (1, 0):
            Task {
                try? await LLFeedback.email(sendTo: "", presentBy: self)
            }
        case (2, 0):
            pushAction()
        case (2, 1):
            modalAction()
        default: break
        }
        
    }
}

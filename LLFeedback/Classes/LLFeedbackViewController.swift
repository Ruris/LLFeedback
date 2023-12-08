//
//  LLFeedbackViewController.swift
//  LLFeedback
//
//  Created by ZHK on 2023/12/7.
//  
//

import UIKit
import QMUIKit
import SnapKit

/// 反馈页面
class LLFeedbackViewController: UIViewController {
    
    /// 背景视图
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    /// 输入视图
    private let textView: QMUITextView = {
        let textView = QMUITextView()
        textView.maximumTextLength = 500
        textView.placeholder = NSLocalizedString("请输入您的建议或问题", comment: "请输入您的建议或问题")
        textView.placeholderColor = .systemGray2
        textView.font = .systemFont(ofSize: 17)
        textView.layer.cornerRadius = 5.0
        return textView
    }()
    
    /// 文本长度
    private let lenLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.text = "0 / 500"
        return label
    }()
    
    /// 邮箱
    private let textField: QMUITextField = {
        let textField = QMUITextField()
        textField.backgroundColor = .systemBackground
        textField.placeholder = NSLocalizedString("请留下您的邮箱方便我们联系您", comment: "请留下您的邮箱方便我们联系您")
        textField.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        textField.layer.cornerRadius = 5.0
        textField.placeholderColor = .systemGray2
        textField.font = .systemFont(ofSize: 17)
        return textField
    }()
    
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: Action
    
    /// 发送
    @objc private func sendAction() {
        
    }
    
    /// 返回
    @objc private func backAction() {
        navigationController?.dismiss(animated: true)
    }
}

extension LLFeedbackViewController {
    
    // MARK: - UI
    
    private func setupUI() {
        title = NSLocalizedString("用户反馈", comment: "用户反馈")
        view.backgroundColor = .systemGroupedBackground
        
        /// 提交按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .done, target: self, action: #selector(sendAction))
        
        /// 如果当前页面是被 `模态` 出现, 则自定义返回按钮
        if presentingViewController != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(backAction))
        }
        
        view.addSubview(backView)
        backView.addSubview(textView)
        backView.addSubview(lenLabel)
        view.addSubview(textField)
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
            make.height.equalTo(backView.snp.width).multipliedBy(0.6)
        }
        
        textView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(lenLabel.snp.top).offset(-5.0)
        }
        
        lenLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.0)
            make.bottom.equalToSuperview().offset(-10.0)
            make.width.equalTo(100.0)
            make.height.equalTo(15.0)
        }
        
        textField.snp.makeConstraints { make in
            make.left.right.equalTo(backView)
            make.top.equalTo(backView.snp.bottom).offset(20.0)
            make.height.equalTo(44)
        }
    }
}

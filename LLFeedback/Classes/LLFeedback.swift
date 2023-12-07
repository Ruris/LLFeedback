//
//  LLFeedback.swift
//  LLFeedback
//
//  Created by ZHK on 2023/12/7.
//
//


/// <#Description#>
public struct LLFeedback {
 
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

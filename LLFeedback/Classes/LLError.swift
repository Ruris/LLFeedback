//
//  LLError.swift
//  LLGeneral
//
//  Created by ZHK on 2021/10/29.
//  
//

import Foundation

public struct LLError: Error {
    
    /// 错误信息
    let message: String
    
    var localizedDescription: String { message }
    
    init(_ message: String?) {
        self.message = message ?? "未知错误"
    }
}

extension LLError: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self.message = value
    }
}

extension LLError: LocalizedError {
    
    public var errorDescription: String? {
        return message
    }
}

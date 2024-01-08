//
//  UserDefaults.PropertyWrapper.swift
//  Mew
//
//  Created by ZHK on 2023/9/6.
//  
//

import Foundation

@propertyWrapper
struct Standard<T> {
    
    public let defaultValue: T
    
    public let key: String
    
    var wrappedValue: T {
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            #if DEBUG
            print("Standard(\(key)) 写入结果: \(newValue)", UserDefaults.standard.synchronize())
            #else
            UserDefaults.standard.synchronize()
            #endif
        }
        get {
            UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
        }
    }
    
}

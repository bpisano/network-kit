//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 09/08/2023.
//

import Foundation

public protocol HttpHeaders { }

public extension HttpHeaders {
    func dictionaryHeaders(dateFormatter: DateFormatter) -> [String: String] {
        let mirror: Mirror = Mirror(reflecting: self)
        return mirror.children.reduce(into: [String: String]()) { parameters, children in
            if let key = children.label {
                if let dateValue = children.value as? Date {
                    parameters[key] = dateFormatter.string(for: dateValue)
                } else if let value = unwrap(children.value) {
                    parameters[key] = "\(value)"
                }
            } else if let keyValuePair = children.value as? (key: String, value: Any) {
                parameters[keyValuePair.key] = "\(keyValuePair.value)"
            }
        }
    }
    
    private func unwrap(_ value: Any) -> Any? {
        let mirror = Mirror(reflecting: value)
        if mirror.displayStyle != .optional {
            return value
        }
        if mirror.children.isEmpty {
            return nil
        }
        let (_, unwrappedValue) = mirror.children.first!
        return unwrappedValue
    }
}

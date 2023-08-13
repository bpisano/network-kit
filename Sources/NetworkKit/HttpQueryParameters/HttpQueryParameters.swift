//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 09/08/2023.
//

import Foundation

/// A protocol representing an object that can be passed as parameters of an ``HttpRequest``.
public protocol HttpQueryParameters { }

public extension HttpQueryParameters {
    func queryItems(dateFormatter: DateFormatter) -> [URLQueryItem] {
        let mirror: Mirror = Mirror(reflecting: self)
        return mirror.children.reduce(into: [URLQueryItem]()) { parameters, children in
            if let key = children.label {
                if let dateValue = children.value as? Date {
                    parameters = parameters + [URLQueryItem(
                        name: key,
                        value: dateFormatter.string(from: dateValue)
                    )]
                } else if let value = unwrap(children.value) {
                    parameters = parameters + [URLQueryItem(
                        name: key,
                        value: "\(value)"
                    )]
                }
            } else if let keyValuePair = children.value as? (key: String, value: Any) {
                parameters = parameters + [URLQueryItem(
                    name: keyValuePair.key,
                    value: "\(keyValuePair.value)"
                )]
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

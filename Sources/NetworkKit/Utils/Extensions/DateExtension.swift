//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 09/08/2023.
//

import Foundation

public extension Date {
    var datefnsString: String {
        let formatter: ISO8601DateFormatter = .datefns
        return formatter.string(from: self)
    }
}

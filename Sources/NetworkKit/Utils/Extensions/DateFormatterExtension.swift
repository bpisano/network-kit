//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 09/08/2023.
//

import Foundation

public extension ISO8601DateFormatter {
    static var datefns: ISO8601DateFormatter {
        let formatter: ISO8601DateFormatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withFractionalSeconds,
            .withColonSeparatorInTime
        ]
        return formatter
    }
}

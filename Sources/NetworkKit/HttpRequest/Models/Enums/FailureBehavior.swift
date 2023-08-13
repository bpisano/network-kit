//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

public enum FailureBehavior {
    case `default`
    case throwError(_ error: Error)
    case refreshAccessToken
}

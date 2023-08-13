//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

/// A protocol used to provide and refresh an access token.
public protocol AccessTokenProvider {
    var accessToken: String? { get }

    func refreshAccessToken() async throws
}

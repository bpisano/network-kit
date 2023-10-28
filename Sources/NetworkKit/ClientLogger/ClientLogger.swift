//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 27/10/2023.
//

import Foundation

public protocol ClientLogger {
    func logProgress(request: some HttpRequest, from client: Client)
    func logSuccess(receivedData: Data, for request: some HttpRequest, from client: Client)
    func logRefreshToken(receivedData: Data, for request: some HttpRequest, from client: Client)
    func logError(receivedData: Data, for request: some HttpRequest, from client: Client)
}

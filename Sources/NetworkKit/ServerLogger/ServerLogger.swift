//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 27/10/2023.
//

import Foundation

public protocol ServerLogger {
    func logProgress(request: some HttpRequest, from server: Server)
    func logSuccess(receivedData: Data, for request: some HttpRequest, from server: Server)
    func logRefreshToken(receivedData: Data, for request: some HttpRequest, from server: Server)
    func logError(receivedData: Data, for request: some HttpRequest, from server: Server)
}

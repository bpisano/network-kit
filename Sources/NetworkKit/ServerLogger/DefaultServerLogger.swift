//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 27/10/2023.
//

import Foundation
import OSLog

public final class DefaultServerLogger: ServerLogger {
    private let logger: Logger

    public init(identifier: String) {
        self.logger = Logger(subsystem: identifier, category: "network")
    }

    public func logProgress(request: some HttpRequest, from server: Server) {
        guard let description: String = try? request.urlRequest(server: server).debugDescription else { return }
        logger.info("⏳ \(description)")
    }

    public func logSuccess(receivedData: Data, for request: some HttpRequest, from server: Server) {
        guard let description: String = try? request.urlRequest(server: server).debugDescription else { return }
        let data: String = stringData(for: receivedData)
        logger.log(level: .info, "\(description) \(data, privacy: .private)")
    }

    public func logRefreshToken(receivedData: Data, for request: some HttpRequest, from server: Server) {
        guard let description: String = try? request.urlRequest(server: server).debugDescription else { return }
        let data: String = stringData(for: receivedData)
        logger.warning("🔄 \(description) \(data, privacy: .private)")
    }

    public func logError(receivedData: Data, for request: some HttpRequest, from server: Server) {
        guard let description: String = try? request.urlRequest(server: server).debugDescription else { return }
        let data: String = stringData(for: receivedData)
        logger.log(level: .fault, "\(description) \(data, privacy: .private)")
    }

    private func stringData(for receivedData: Data) -> String {
        if let jsonData = receivedData.prettyPrintedJSON {
            return "\n \(jsonData)"
        } else if let stringData = String(data: receivedData, encoding: .utf8) {
            return "\n \(stringData)"
        } else {
            return ""
        }
    }
}

extension ServerLogger where Self == DefaultServerLogger {
    static func `default`(identifier: String) -> Self {
        .init(identifier: identifier)
    }
}

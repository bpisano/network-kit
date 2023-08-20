//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

struct HttpRequestPerformer {
    private let server: Server
    
    init(server: Server) {
        self.server = server
    }

    func perform(
        _ request: some HttpRequest,
        onProgress: @escaping (Double) -> Void
    ) async throws -> (data: Data, response: HTTPURLResponse) {
        let urlRequest: URLRequest = try request.urlRequest(server: server)
        let (bytes, response) = try await URLSession.shared.bytes(for: urlRequest)
        let length: Int = Int(response.expectedContentLength)
        var data: Data = .init(capacity: length)
        for try await byte in bytes {
            data.append(byte)
            let progress: Double = abs(Double(data.count) / Double(length))
            onProgress(progress)
        }
        guard let httpResponse = response as? HTTPURLResponse else { throw ResponseError.internalServerError }
        return (data, httpResponse)
    }
}

extension HttpRequestPerformer {
    enum ReponseError: LocalizedError {
        case invalidResponseType
        
        var errorDescription: String? {
            switch self {
            case .invalidResponseType:
                return "Invalide response format."
            }
        }
    }
}

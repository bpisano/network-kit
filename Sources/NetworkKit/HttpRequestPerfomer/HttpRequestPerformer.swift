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
    
    func perform(_ request: HttpRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let urlRequest: URLRequest = try request.urlRequest(server: server)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
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

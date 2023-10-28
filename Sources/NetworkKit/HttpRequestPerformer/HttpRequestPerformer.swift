//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

struct HttpRequestPerformer {
    private let client: Client
    
    init(client: Client) {
        self.client = client
    }

    func perform(
        _ request: some HttpRequest,
        onProgress: ((Progress) -> Void)? = nil
    ) async throws -> (data: Data, response: HTTPURLResponse) {
        let urlRequest: URLRequest = try request.urlRequest(client: client)
        let (bytes, response) = try await URLSession.shared.bytes(for: urlRequest)
        let length: Int = Int(response.expectedContentLength)
        var data: Data = .init(capacity: length)
        var receivedBytesCount: Int64 = 0
        let progress = Progress(totalUnitCount: Int64(length))
        for try await byte in bytes {
            data.append(byte)
            receivedBytesCount += 1
            progress.completedUnitCount = receivedBytesCount
            onProgress?(progress)
        }
        guard let httpResponse = response as? HTTPURLResponse else { throw ResponseCode.internalServerError }
        return (data, httpResponse)
    }
}

extension HttpRequestPerformer {
    enum ResponseError: LocalizedError {
        case invalidResponseType
        
        var errorDescription: String? {
            switch self {
            case .invalidResponseType:
                return "Invalid response format."
            }
        }
    }
}

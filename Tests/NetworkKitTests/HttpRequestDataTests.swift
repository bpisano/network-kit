//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 16/08/2023.
//

import Foundation
import XCTest

final class HttpRequestDataTests: XCTestCase {
    func testImageUpload() async throws {
        guard let url = Bundle.module.url(forResource: "test_image", withExtension: "jpeg") else {
            XCTFail("Image not found.")
            return
        }
        let imageData: Data = try Data(contentsOf: url)
        let server: TestServer = .init()
        let receivedData: Data = try await server.performRaw(.postImage(data: imageData))
        XCTAssertEqual(receivedData, imageData)
    }
}

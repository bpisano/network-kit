//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 13/08/2023.
//

import Foundation
import XCTest

func AsyncAssertThrowsError<T>(
    _ operation: @autoclosure () async throws -> T,
    handleError: ((_ error: Error) async -> Void)? = nil
) async {
    var taskError: Error?
    do {
        let _ = try await operation()
    } catch {
        taskError = error
    }
    XCTAssertNotNil(taskError)
    if let taskError {
        await handleError?(taskError)
    }
}

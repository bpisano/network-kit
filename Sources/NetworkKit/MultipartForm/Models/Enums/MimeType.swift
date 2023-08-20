//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

public enum MimeType {
    case pngImage
    case jpegImage
    case some(_ mimeType: String)

    var stringValue: String {
        switch self {
        case .pngImage:
            return "image/png"
        case .jpegImage:
            return "image/jpeg"
        case let .some(mimeType):
            return mimeType
        }
    }
}

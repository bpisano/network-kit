//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 16/08/2023.
//

import Foundation
import NetworkKit

struct PostImageRequest: HttpRequest {
    let path: String = "/image"
    let method: HttpMethod = .post

    private let imageData: Data

    init(imageData: Data) {
        self.imageData = imageData
    }

    var body: some HttpBody {
        MultipartForm {
            DataField(
                named: "image",
                data: imageData,
                mimeType: .jpegImage,
                fileName: "image"
            )
        }
    }
}

extension HttpRequest where Self == PostImageRequest {
    static func postImage(data: Data) -> Self {
        .init(imageData: data)
    }
}

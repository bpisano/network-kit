//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

@resultBuilder
public struct MultipartFormBuilder {
    public static func buildBlock(_ components: MultipartFormField...) -> [any MultipartFormField] {
        components
    }
}

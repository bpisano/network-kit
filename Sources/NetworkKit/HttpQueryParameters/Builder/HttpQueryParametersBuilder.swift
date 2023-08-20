//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

@resultBuilder
public struct HttpQueryParamertersBuilder {
    public static func buildBlock(_ components: HttpQueryParameter...) -> HttpQueryParameters {
        components.reduce(into: [String: String]()) { queryParameters, queryParameter in
            queryParameters[queryParameter.key] = queryParameter.value
        }
    }
}

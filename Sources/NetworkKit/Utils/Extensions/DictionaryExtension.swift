//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 09/08/2023.
//

import Foundation

extension Dictionary: HttpQueryParameters where Key == String {
    func queryItems(dateFormatter: DateFormatter) -> [URLQueryItem] {
        map({ URLQueryItem(name: $0, value: "\($1)") })
    }
}

extension Dictionary: HttpHeaders where Key == String { }

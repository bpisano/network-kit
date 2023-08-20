//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

public protocol MultipartFormField {
    func data(with boundary: String) -> Data
}

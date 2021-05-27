//
//  Utf8 Extension.swift
//  Memorize
//
//  Created by Omer on 4/9/21.
//

import Foundation

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}

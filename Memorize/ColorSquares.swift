//
//  ColorSquares.swift
//  Memorize
//
//  Created by Omer on 4/25/21.
//

import SwiftUI

struct ColorSquare: Identifiable {
    var name: String
    var color: UIColor.RGB
    let id: Int
    private static var idKeeper: Int = 0
    
    init(name: String, color: UIColor.RGB) {
        ColorSquare.idKeeper += 1
        self.name = name
        self.color = color
        self.id = ColorSquare.idKeeper
        
    }
    
}

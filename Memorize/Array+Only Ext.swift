//
//  Array+Only Ext.swift
//  Memorize
//
//  Created by Omer on 2/16/21.
//

import Foundation

extension Array {
    var only: Element? {
        self.count == 1 ? first : nil
    }
}

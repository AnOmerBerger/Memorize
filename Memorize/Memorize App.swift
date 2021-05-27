//
//  Memorize App.swift
//  Memorize
//
//  Created by Omer on 4/21/21.
//

import SwiftUI

@main

struct MemorizeApp: App {
    private var store = MemoryGameStore()
    
    var body: some Scene {
        WindowGroup {
            GameThemeChooser().environmentObject(store)
        }
    }
}

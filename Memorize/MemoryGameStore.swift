//
//  MemoryGameStore.swift
//  Memorize
//
//  Created by Omer on 4/20/21.
//

import SwiftUI
import Combine

class MemoryGameStore: ObservableObject {
    
    @Published var themes: [MemoryGame<String>.Theme]?
    
    private var autosave: AnyCancellable?
    
    private let defaultsKey = "MemoryGameStore.Autosave2"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey) {
            themes = try? PropertyListDecoder().decode(Array<MemoryGame<String>.Theme>.self, from: data)
        } else {
            themes = [MemoryGame<String>.Theme]()
        }
        autosave = $themes.sink { themes in
            UserDefaults.standard.set(try? PropertyListEncoder().encode(themes), forKey: self.defaultsKey)
        }
    }
    
    func removeTheme(_ theme: MemoryGame<String>.Theme) {
        if let index = themes?.firstIndex(matching: theme) {
            themes?.remove(at: index)
        }
    }
    
    func addTheme() {
        themes!.append(defaultTheme)
    }
    
    private var defaultTheme: MemoryGame<String>.Theme {
        MemoryGame<String>.Theme(name: "Default", color: UIColor.RGB(red: 0, green: 0, blue: 1, alpha: 1), emojis: ["⏱","⏰","🕰"], numberOfPairs: 3)
    }
    
    func loadBasicThemes() {
        themes!.append(MemoryGame<String>.Theme(name: "Winter", color: UIColor.RGB(red: 0, green: 0, blue: 1, alpha: 1), emojis: ["🥶","❄️","⛄️","☂️","💨"], numberOfPairs: 5))
            themes!.append(MemoryGame<String>.Theme(name: "Animals", color: UIColor.RGB(red: 0.9, green: 0.9, blue: 0.1, alpha: 1), emojis: ["🐒","🦅","🐈","🐇"], numberOfPairs: 4))
            themes!.append(MemoryGame<String>.Theme(name: "Flags", color: UIColor.RGB(red: 1, green: 0, blue: 0, alpha: 1), emojis: ["🇪🇺", "🇮🇱", "🇺🇸", "🇯🇲", "🇺🇾", "🇹🇷" ,"🇷🇺"], numberOfPairs: 7))
            themes!.append(MemoryGame<String>.Theme(name: "Foods", color: UIColor.RGB(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), emojis: ["🍟", "🍔", "🥞", "🥯", "🥨", "🍣"], numberOfPairs: 6))
            themes!.append(MemoryGame<String>.Theme(name: "Balls", color: UIColor.RGB(red: 0, green: 1, blue: 0, alpha: 1), emojis: ["🏈", "⚾️", "🎾", "🎱"], numberOfPairs: 4))
            themes!.append(MemoryGame<String>.Theme(name: "Halloween", color: UIColor.RGB(red: 1, green: 0.54901960784, blue: 0, alpha: 1), emojis: ["👻","🎃","🕷","💀","☠️"], numberOfPairs: 5))
    }
}

//extension Array where Element == MemoryGame<String>.Theme {
//    var asPropertyList: String {
//
//    }
//}

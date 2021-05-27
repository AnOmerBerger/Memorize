//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Omer on 1/26/21.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
     
    private var startingTheme: MemoryGame<String>.Theme
    
    
    
    init(theme: MemoryGame<String>.Theme) {
        model = MemoryGame<String>(numberOfPairs: theme.numberOfPairs,
                                   name: theme.name,
                                   color: theme.color,
                                   emojis: theme.emojis) { pairIndex in
            theme.emojis[pairIndex]
        }
        self.startingTheme = theme
    }
    
    // MARK: - Access to Model
    
    var themeName: String { model.currentTheme.name}
    var themeColor: Color { Color(model.currentTheme.color)}
    var score: Int { model.score }
    var scoreDirection: Int { model.scoreDirection }
    
    var startGamePressed: Bool {
        model.startGamePressed
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
        
    }
    
    func pressStartGame() {
        model.pressStartGame()
        print(model.currentTheme.json?.utf8 as Any)
    }
    
    func restartGame() {
        model = MemoryGame<String>(numberOfPairs: startingTheme.numberOfPairs,
                                   name: startingTheme.name,
                                   color: startingTheme.color,
                                   emojis: startingTheme.emojis) { pairIndex in
            startingTheme.emojis[pairIndex]
        }
    }
    
    
}

//private static func createMemoryGame() -> MemoryGame<String> {
//    var themes = [MemoryGame<String>.Theme]()
//    themes.append(MemoryGame<String>.Theme(name: "Winter", color: UIColor.RGB(red: 0, green: 0, blue: 1, alpha: 1), emojis: ["🥶","❄️","⛄️","☂️","💨"], numberOfPairs: 5))
//    themes.append(MemoryGame<String>.Theme(name: "Animals", color: UIColor.RGB(red: 0.9, green: 0.9, blue: 0.1, alpha: 1), emojis: ["🐒","🦅","🐈","🐇"], numberOfPairs: 4))
//    themes.append(MemoryGame<String>.Theme(name: "Flags", color: UIColor.RGB(red: 1, green: 0, blue: 0, alpha: 1), emojis: ["🇪🇺", "🇮🇱", "🇺🇸", "🇯🇲", "🇺🇾", "🇹🇷" ,"🇷🇺"], numberOfPairs: 7))
//    themes.append(MemoryGame<String>.Theme(name: "Foods", color: UIColor.RGB(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), emojis: ["🍟", "🍔", "🥞", "🥯", "🥨", "🍣"], numberOfPairs: 6))
//    themes.append(MemoryGame<String>.Theme(name: "Balls", color: UIColor.RGB(red: 0, green: 1, blue: 0, alpha: 1), emojis: ["🏈", "⚾️", "🎾", "🎱"], numberOfPairs: 4))
//    themes.append(MemoryGame<String>.Theme(name: "Halloween", color: UIColor.RGB(red: 1, green: 0.54901960784, blue: 0, alpha: 1), emojis: ["👻","🎃","🕷","💀","☠️"], numberOfPairs: 5))
//    let chosenTheme = themes[Int.random(in: 0..<themes.count)]
//    return MemoryGame<String>(numberOfPairs: chosenTheme.numberOfPairs, name: chosenTheme.name, color: chosenTheme.color, emojis: chosenTheme.emojis) { pairIndex in
//        chosenTheme.emojis[pairIndex]
//    }
//
//}

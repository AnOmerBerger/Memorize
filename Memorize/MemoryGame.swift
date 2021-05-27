//
//  MemoryGame.swift
//  Memorize
//
//  Created by Omer on 1/26/21.
//

import SwiftUI
import Combine

struct MemoryGame<CardContent> where CardContent: Equatable {
    
   // MARK: - Start Game
    var startGamePressed: Bool = false
    mutating func pressStartGame() {
        startGamePressed = true
    }
    // MARK: - Theme Vars
    
    var currentTheme: Theme
    
//    private(set) var themeName: String
//    private(set) var themeColor: UIColor.RGB
    private(set) var score: Int = 0
    private(set) var scoreDirection: Int = 0
    private(set) var cards: Array<Card>
    
    // MARK: - Logic & Init
    private var indexOfFirstCardFaceUp: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp}.only}
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    func bonusAdded(card: Card) -> Int {
        switch Double(card.bonusTimeRemaining) {
        case 4.0...6.0:
            return 3
        case 2.0..<4.0:
            return 2
        case 0.01..<2.0:
            return 1
        default:
            return 0
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfFirstCardFaceUp {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2 + bonusAdded(card: cards[chosenIndex]) + bonusAdded(card: cards[potentialMatchIndex])
                    scoreDirection = 1
                }
                else if cards[chosenIndex].content != cards[potentialMatchIndex].content {
                    if cards[chosenIndex].hasBeenSeen && cards[potentialMatchIndex].hasBeenSeen {
                        score -= 2
                        scoreDirection = -1
                    }
                    else if cards[chosenIndex].hasBeenSeen || cards[potentialMatchIndex].hasBeenSeen {
                       score -= 1
                       scoreDirection = -1
                    }
                    cards[chosenIndex].hasBeenSeen = true
                    cards[potentialMatchIndex].hasBeenSeen = true
                }
                cards[chosenIndex].isFaceUp = !cards[chosenIndex].isFaceUp
            } else {
                indexOfFirstCardFaceUp = chosenIndex
            }
        }
    }
   
    init(numberOfPairs: Int, name: String, color: UIColor.RGB, emojis: [String], cardContentFactory: (Int) -> CardContent) {
        currentTheme = Theme(name: name, color: color, emojis: emojis, numberOfPairs: numberOfPairs)
        cards = [Card]()
        for pairIndex in 0..<numberOfPairs {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
        cards.shuffle()
    }
    
    struct Theme: Encodable, Identifiable, Decodable {
        var name: String
        var color: UIColor.RGB
        var emojis: [String]
        var numberOfPairs: Int
        var id = UUID()
        var json: Data? {
            try? JSONEncoder().encode(self)
        }
        
        init(name: String, color: UIColor.RGB, emojis: [String], numberOfPairs: Int) {
            self.name = name
            self.color = color
            self.emojis = emojis
            self.numberOfPairs = numberOfPairs
        }
        
        init?(json: Data?) {
            if json != nil, let newTheme = try? JSONDecoder().decode(Theme.self, from: json!) {
                self = newTheme
            } else {
                return nil
            }
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var hasBeenSeen: Bool = false
        var content: CardContent
        var id: Int
       
        
        
        //MARK: - Bonus Time
        
        
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceTimeUp + Date().timeIntervalSince(lastFaceUpDate)
            }
            else {
                return pastFaceTimeUp
            }
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceTimeUp: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        var isConsumingBonus: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        private mutating func startUsingBonusTime() {
            if isConsumingBonus, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        private mutating func stopUsingBonusTime() {
            pastFaceTimeUp = faceUpTime
            lastFaceUpDate = nil
        }
    }
}

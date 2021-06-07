//
//  Deck.swift
//  SetGame
//
//  Created by Joel Cranston on 6/26/20.
//  Copyright © 2020 Joel Cranston. All rights reserved.
//

import Foundation
/// maintains a deck of set cards
struct Deck: IteratorProtocol {
    typealias Element = Card
    mutating func next() -> Card? {
        return dealCard()
    }
    private var nextCard = 0
    mutating func dealCard() -> Card? {
        if nextCard < cards.count{
            let card = cards[nextCard]
            nextCard += 1
            return card
        } else {
            return nil
        }
    }
    var cards: [Card] = [] 

    /// Resets deck
    mutating func resetDeck(){
        nextCard = 0
        cards.shuffle()
    }
    init (){
        //Fill deck with one of each card
        for cardValue in CardValue.allCases {
            for cardFill in CardFill.allCases {
                for cardColor in CardColor.allCases{
                    for cardSymbol in CardSymbol.allCases {
                        cards.append(Card(symbol: cardSymbol,
                                          value: cardValue,
                                          fill: cardFill,
                                          color: cardColor))
                    }
                }
            }
        }
        cards.shuffle()
    }
}


/// Defines a SET card
struct Card: Hashable{
    let symbol: CardSymbol
    let value: CardValue
    let fill: CardFill
    let color: CardColor
    
    subscript(attribute: Int) -> Int?{
        get {
            switch attribute {
                case 0: return symbol.rawValue
                case 1: return value.rawValue
                case 2: return fill.rawValue
                case 3: return color.rawValue
                default: return nil
            }
        }
    }
}
extension Card: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(self.value) \(self.color) \(self.fill) \(self.symbol)"
    }
}
protocol CardAttribute{
    var value: Int { get }
}
enum CardSymbol:Int, CaseIterable, CardAttribute {
    var value: Int{
        self.rawValue
    }
    case circle = 0, triangle, square
}
enum CardValue:Int, CaseIterable, CardAttribute{
    var value: Int {
        self.rawValue
    }
    case one = 0, two, three
}
enum CardFill:Int, CaseIterable, CardAttribute {
    var value: Int {
        self.rawValue
    }
    case empty = 0 , shaded, solid
}
enum CardColor:Int, CaseIterable, CardAttribute {
    var value: Int {
        self.rawValue
    }
    case red = 0, green, blue
}

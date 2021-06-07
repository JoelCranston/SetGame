//
//  SetGame.swift
//  SetGame
//
//  Created by Joel Cranston on 6/26/20.
//  Copyright © 2020 Joel Cranston. All rights reserved.
//

import Foundation
let MISMATCH_PENALTY = 1
let MATCH_POINTS = 1

/// Plays the card game SET
class SetGame {
    /// various game status attributes
    ///
    private(set) var gameStatus = Status()
    private var deck = Deck.init()
    /// Resets the deck and starts new game
    ///
    func startNewGame(){
        deck.resetDeck()
        gameStatus.matchedSets = 0
        gameStatus.score = 0
    }
    // Called when a user selects a card
    //func select(card: Card){
    //}
    /// Called when user asks for more cards
    /// -Return: next card in deck or nil
    func dealCard() -> Card?{
        if let card = deck.next(){
            return card
        }
        return nil
    }
    func cardsMatch(_ card: [Card]) -> Bool{
        let cardsMatch  = (attributeMatches([card[0].color, card[1].color, card[2].color])
            && attributeMatches([card[0].fill, card[1].fill, card[2].fill])
            && attributeMatches([card[0].symbol, card[1].symbol, card[2].symbol])
            && attributeMatches([card[0].value, card[1].value, card[2].value]))
        if cardsMatch {
            gameStatus.matchedSets += 1
        }else{
            gameStatus.score -= MISMATCH_PENALTY
        }
        return cardsMatch
    }
    
    /// checks if the card attribute  is a match
    func attributeMatches <T: Equatable>(_ attribute: [T]) -> Bool {
        
        switch attribute[0] {
            case attribute[1]:
                return attribute[1] == attribute[2]   // all match return true
            case attribute[2]: //one matches but not both, return false
                return false
            default:
                return attribute[1] != attribute[2] // none match, return true
        }
    }

}
/// Data type for storing game status
struct Status {
    var score = 0
    var matchedSets = 0 {
        didSet{
            score += MATCH_POINTS
        }
    }
    //var cardsLeftinDeck = 0
    //var selectedCardsMatch = false
}

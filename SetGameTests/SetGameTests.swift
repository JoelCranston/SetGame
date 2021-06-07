//
//  SetGameTests.swift
//  SetGameTests
//
//  Created by Joel Cranston on 6/26/20.
//  Copyright © 2020 Joel Cranston. All rights reserved.
//

import XCTest
//import SetGame
@testable import SetGame



class SetGameTests: XCTestCase {
    let card1 = Card.init(symbol: CardSymbol.circle,
                          value: CardValue.one,
                          fill: CardFill.empty,
                          color: CardColor.blue)
    let card2 = Card.init(symbol: CardSymbol.circle,
                          value: CardValue.one,
                          fill: CardFill.shaded,
                          color: CardColor.blue)
    let card3 = Card.init(symbol: CardSymbol.circle,
                          value: CardValue.one,
                          fill: CardFill.solid,
                          color: CardColor.blue)
    var sut: SetGame!
    override func setUp() {
        super.setUp()
        sut = SetGame()
        sut.startNewGame()
    }

    override func tearDown() {
        sut = nil
    }
    /// tests that the start new game properly resets the deck and game status values
    func testStartNewGame() {
        var card: Card?
        repeat {
            card = sut.dealCard()
        } while card != nil
        XCTAssertTrue(sut.cardsMatch([card1,card2,card3]))
        XCTAssertEqual(sut.gameStatus.matchedSets, 1)
        XCTAssertEqual(sut.gameStatus.score, MATCH_POINTS)
        sut.startNewGame()
        card = sut.dealCard()
        XCTAssertEqual(sut.gameStatus.matchedSets, 0,"matches not getting retset")
        XCTAssertEqual(sut.gameStatus.score, 0,"score not getting reset")
        XCTAssertNotNil(card,"card nil after newgame")
    }
    /// Test that there are exactly 81 cards and none are nil, or duplicates
    func testDealCard(){
        var testedCards: [Card] = []
        sut.startNewGame()
        for index in 0...80 {
            let card = sut.dealCard()
            XCTAssertNotNil(card, "dealing nil card at index \(index)")
            XCTAssertFalse(testedCards.contains(card!), "duplicate card")
            testedCards.append(card!)
        }
        let card = sut.dealCard()
        XCTAssertNil(card,"Too many cards")
    }
    
    /// test that given any two cards there is one and only one matching card.
    func testMatching(){
        var cards = Deck().cards
        let card1 = cards.removeLast()
        let card2 = cards.removeLast()
        var matches = 0
        var cardMatches: [Card] = []

        for card in cards {
            if sut.cardsMatch([card1, card2, card]) {
                matches += 1
                cardMatches.append(card)
            }
        }
        XCTAssertEqual(matches, 1, "Incorrett number af matches: \(card1) and \(card2) matched \(cardMatches)")
    }
    /// Tests that the attribute matching is working properly: all same or all different
    func testAttributeMatches(){
        XCTAssertTrue( sut.attributeMatches([card1.fill,card2.fill,card3.fill]), "Does not detect match of all different")
        XCTAssertTrue( sut.attributeMatches([card1.fill,card1.fill,card1.fill]), "Does not detect match of all same")
        XCTAssertFalse( sut.attributeMatches([card1.fill,card2.fill,card2.fill]), "Does detect non matching attribute")
        XCTAssertFalse( sut.attributeMatches([card1.fill,card1.fill,card3.fill]), "Does detect non matching attribute")
        XCTAssertFalse( sut.attributeMatches([card1.fill,card2.fill,card1.fill]), "Does detect non matching attribute")
    }
    
}

//
//  Deck.swift
//  SetGameTests
//
//  Created by Joel Cranston on 6/26/20.
//  Copyright © 2020 Joel Cranston. All rights reserved.
//

import XCTest
@testable import SetGame

class DeckTests: XCTestCase {
    var sut: Deck!
    override func setUp() {
        super.setUp()
        sut = Deck.init()
    }
    func testFilldeck() {
        sut.numberOfCards
    }

}

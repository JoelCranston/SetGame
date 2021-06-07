//
//  ViewController.swift
//  SetGame
//
//  Created by Joel Cranston on 6/26/20.
//  Copyright © 2020 Joel Cranston. All rights reserved.
//

import UIKit
import SwiftUI

let SELECTED_COLOR = UIColor.blue.cgColor
let UNSELECTED_COLOR = UIColor.gray.cgColor
let MATCHED_COLOR = UIColor.green.cgColor
let MISMATCH_COLOR = UIColor.red.cgColor
let CARD_COLOR1 = UIColor.red
let CARD_COLOR2 = UIColor.blue
let CARD_COLOR3 = UIColor.green
let STARTINGBUTTONS = 12

class ViewController: UIViewController {
    /// Current maximum number of buttons shown on screen
    var maxButtons = STARTINGBUTTONS
    /// Current number of innitualized buttons
    var activeButtons = 0
    /// The game model
    var game: SetGame = SetGame()
    /// An array of Int, that indexes into buttons: [UIButton]
    var selectedButtons = [Int]() {
        didSet { // check for match when three are selected
            if selectedButtons.count == 3 {
                if game.cardsMatch(getSelectedCards()) {
                    //match
                    for index in selectedButtons{
                        markAsMatched(button: buttons[index])
                    }
                }else{
                    //no match
                    for index in selectedButtons{
                        markAsMismatched(button: buttons[index])
                    }
                }
            }
        }
    }
    /// Dictionary of button to card
    var cardsLookup = [UIButton : Card]()
    /// card buttons
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            //do some initial value or formatting
            scoreLabel.textColor = UIColor.systemGray
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        resetDisplay()
    }
    let shapes = ["●","▲","■"]
    //Gets the symbol string from Card
    private func getSymbols(from gameCard: Card ) -> String {
        let symbol: String
        switch gameCard.symbol {
            case .circle:
                symbol = shapes[0]
            case .triangle:
                symbol = shapes[1]
            case .square:
                symbol = shapes[2]
        }
        var outputString = ""
        for _ in 0...gameCard.value.value { outputString += symbol }
        return outputString
    }
    
    //gets the color and fill attributes from a Card
    private func getColorAttributes(from gameCard: Card) -> [NSAttributedString.Key : Any] {
        var textAttribute: [NSAttributedString.Key : Any] = [:]
        var color: UIColor
        switch gameCard.color {
            case .red: color = CARD_COLOR1
            case .blue: color = CARD_COLOR2
            case .green: color = CARD_COLOR3
        }
        switch gameCard.fill {
            case .empty:
                textAttribute[NSAttributedString.Key.strokeWidth] = 6.0
                textAttribute[NSAttributedString.Key.strokeColor] = color
            case .shaded:
                textAttribute[NSAttributedString.Key.strokeWidth] = -6.0
                textAttribute[NSAttributedString.Key.strokeColor] = color
                textAttribute[NSAttributedString.Key.foregroundColor] = color.withAlphaComponent(0.3)
            case .solid:
                textAttribute[NSAttributedString.Key.strokeWidth] = 0
                textAttribute[NSAttributedString.Key.foregroundColor] = color
        }
        return textAttribute
    }
    
    private func setCardAttributes(for displayCard: UIButton! ) {
        //only initualize the active cards
        if activeButtons < maxButtons {
            activeButtons += 1
            // get a card from the game
            if let gameCard = game.dealCard() {
                displayCard.isHidden = false
                let symbol = getSymbols(from: gameCard)
                let textAttribute = getColorAttributes(from: gameCard)
                let string = NSAttributedString.init(string: symbol, attributes: textAttribute)
                displayCard.setAttributedTitle(string, for: UIControl.State.normal)
                cardsLookup[displayCard] = gameCard
                
            }else{//out of cards
                displayCard.isHidden = true
            }
        }else{
            displayCard.isHidden = true
        }
        
    }
    private func markAsSelected(button: UIButton){
        button.layer.borderColor = SELECTED_COLOR
    }
    private func markAsUnselected(button: UIButton){
        button.layer.borderColor = UNSELECTED_COLOR
    }
    private func markAsMatched(button: UIButton){
        button.layer.borderColor = MATCHED_COLOR
    }
    private func markAsMismatched(button: UIButton){
        button.layer.borderColor = MISMATCH_COLOR
    }
    private func resetDisplay(){
        game.startNewGame()
        selectedButtons = []
        cardsLookup = [:]
        maxButtons = STARTINGBUTTONS
        activeButtons = 0
        for button in buttons {
            button.isHidden = false
            button.layer.borderWidth = 3.0
            button.layer.cornerRadius = 8.0
            button.layer.borderColor = UNSELECTED_COLOR
            setCardAttributes(for: button)
        }
    }
    private func getSelectedCards() -> [Card] {
        var cards = [Card]()
        for index in selectedButtons{
            cards.append(cardsLookup[buttons[index]]!)
        }
        return cards
    }
    @IBAction func startNewGame(_ sender: UIButton) {
        resetDisplay()
    }

    fileprivate func replaceMatchedCards() {
        //if there is a matched set then just replace it
        activeButtons -= 3
        for index in selectedButtons{
            markAsUnselected(button: buttons[index])
            setCardAttributes(for: buttons[index])
        }
        selectedButtons = []
    }
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        if let buttonIndex = selectedButtons.first,
            buttons[buttonIndex].layer.borderColor == MATCHED_COLOR{
            replaceMatchedCards()
        }else{ // add more buttons
            if buttons.count >= maxButtons + 3 {
                maxButtons += 3
                setCardAttributes(for: buttons[activeButtons])
                setCardAttributes(for: buttons[activeButtons])
                setCardAttributes(for: buttons[activeButtons])
            }
        }
    }

    @IBSegueAction func showSettings(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: SUIView())
    }
    
    @IBAction func cardTouched(_ sender: UIButton) {
        let currentButtonIndex = buttons.firstIndex(of: sender)!
        if sender.isHidden {
            return
        }
        if selectedButtons.count == 3 {
            if buttons[selectedButtons[0]].layer.borderColor == MISMATCH_COLOR {
            // failed match
                for index in selectedButtons{
                    markAsUnselected(button: buttons[index])
                }
                selectedButtons = []
            }else{
                replaceMatchedCards()
            }
        }else { //less then three buttons selected
            if selectedButtons.contains(currentButtonIndex) {
                //deselect
                markAsUnselected(button: sender)
                selectedButtons.remove(at: selectedButtons.firstIndex(of: currentButtonIndex)!)
            
            }else{
                //select
                markAsSelected(button: sender)
                selectedButtons.append(currentButtonIndex)
            }
        }

        
        
        
    }
    
}


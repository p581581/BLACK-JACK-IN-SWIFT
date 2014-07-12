//
//  BJGameModel.swift
//  BALCK JACK
//
//  Created by 581 on 2014/7/4.
//  Copyright (c) 2014年 581. All rights reserved.
//


import Foundation

extension Array {
    // get last
    var last: T {
    return self[self.endIndex - 1]
    }
}

class BJGameModel {
    
    var BJNotificationGameDidEnd = "BJNotificationGameDidEnd"
    
    enum BJGameStage : Int {
        case Player = 1
        case Dealer
        case GameOver
        
        init() {
            self = .Player
        }
    }
    
    var maxPlayerCards = Int()
    var gameStage = BJGameStage()
    
    var cards = BJCard[]()
    var playerCards =  BJCard[]()
    var dealerCards = BJCard[]()
    var didDealerWin = Bool()
    
    init() {
        maxPlayerCards = 5
        resetGame()
    }
    
    func resetGame(){
        // init the stage and the cards
        self.cards = BJCard().generateAPackOfRandCards()
        self.playerCards =  BJCard[]()
        self.dealerCards = BJCard[]()
        self.gameStage = BJGameStage()
    }
    
    func nextCard() -> BJCard {
        return self.cards.removeLast()
    }
    
    func nextDealerCard() -> BJCard {
        var card = nextCard()
        self.dealerCards.append(card)
        return card
    }
    
    func nextPlayerCard() -> BJCard {
        var card = nextCard()
        self.playerCards.append(card)
        return card
    }
    
    func playerCardAtIndex(index: Int) -> BJCard{
        if index < self.playerCards.count {
            return self.playerCards[index]
        }
        return BJCard()
    }

    func dealerCardAtIndex(index: Int) -> BJCard{
        if index < self.dealerCards.count {
            return self.dealerCards[index]
        }
        return BJCard()
    }
    
    func lastDealerCard() -> BJCard {
        return self.dealerCards.last
    }
    
    func lastPlayerCard() -> BJCard {
        return self.playerCards.last
    }
    
    func updateGameStage() -> BJGameStage{
        
        switch self.gameStage {
        case .Player:
            // check whether the card's score are bust
            if areCardsBust(self.playerCards) {
                
                self.gameStage = .GameOver
                self.didDealerWin = true
                notifyGameDidEnd()
                
            } else if calculateBestScore(self.playerCards) == 21 {
                
                self.gameStage = .Dealer
                
            } else if self.playerCards.count == self.maxPlayerCards {
                
                self.gameStage = .Dealer
                
            }
        case .Dealer:
            // check if we're done now?
            if areCardsBust(self.dealerCards) {
                
                self.gameStage = .GameOver
                self.didDealerWin = false
                notifyGameDidEnd()
                
            } else if self.dealerCards.count == self.maxPlayerCards {
                
                self.gameStage = .GameOver
                calculateWinner()
                notifyGameDidEnd()
                
            } else {
                
                // should the dealer stop, has he won?
                var dealerScore = calculateBestScore(self.dealerCards)
                
                if dealerScore >= 17 {
                // dealer can't stand on less than 17
                    
                    var playerScore = calculateBestScore(self.playerCards)
                    if playerScore <= dealerScore {
                        // Dealer has equalled or beaten the player, so Dealer win.
                        // If not, Dealer keep playing until win or bust.
                        self.didDealerWin = true
                        self.gameStage = .GameOver
                        notifyGameDidEnd()
                    }
                }
            }
            default:
                println("nothing")
        }
        return self.gameStage
    }
    
    func notifyGameDidEnd() {
        // notify view controller that the game is over
        var dict = ["didDealerWin":didDealerWin]
        NSNotificationCenter.defaultCenter().postNotificationName(BJNotificationGameDidEnd, object: self, userInfo: dict)
    }
    
    func calculateBestScore(cards: BJCard[]) -> Int {
        if areCardsBust(cards) {
            return 0
        }
        
        // we have a hand of 21 or less then....
        var card: BJCard
        var highestScore = 0
        var maxLoop = cards.count
        
        for i in 0..maxLoop {
            card = cards[i]
            
            if card.isAnAce() {
                highestScore += 11
            } else if card.isFaceOrTenCard() {
                highestScore += 10
            } else {
                highestScore += card.digit
            }
        }
        
        while highestScore > 21 {
            highestScore -= 10
        }
        
        return highestScore
    }
    
    func areCardsBust(cards: BJCard[]) -> Bool{
        var card: BJCard
        var lowerScore = 0
        var maxLoop = cards.count
        
        for i in 0..maxLoop {
            card = cards[i]
            
            if card.isAnAce() {
                lowerScore += 1
            } else if card.isFaceOrTenCard() {
                lowerScore += 10
            } else {
                lowerScore += card.digit
            }
        }
        
        return lowerScore > 21
    }
    
    func calculateWinner() {
        
        var dealerScore = calculateBestScore(self.dealerCards)
        var playerScore = calculateBestScore(self.playerCards)
        
        if playerScore > dealerScore {
            self.didDealerWin = false
        } else {
            self.didDealerWin = true
        }
    }
    
    func isDealerStage() -> Bool {
        return self.gameStage == .Dealer
    }
    
}
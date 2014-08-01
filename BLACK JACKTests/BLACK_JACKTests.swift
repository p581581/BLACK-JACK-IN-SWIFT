//
//  BLACK_JACKTests.swift
//  BLACK JACKTests
//
//  Created by 581 on 2014/7/8.
//  Copyright (c) 2014年 581. All rights reserved.
//

import XCTest
import UIKit

class BLACK_JACKTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBJCard() {
        // This is an example of a functional test case.
        
        var card : BJCard
        
        card = BJCard(digit: 1, suit: .Spade)
        XCTAssert(card.isAnAce(), "Digit Ace error")
        card = BJCard(digit: 2, suit: .Club)
        XCTAssert(!card.isAnAce(), "Digit not Ace error")
        
        card = BJCard(digit: 10, suit: .Club)
        XCTAssert(card.isFaceOrTenCard(), "Digit Ten error")
        card = BJCard(digit: 13, suit: .Club)
        XCTAssert(card.isFaceOrTenCard(), "Digit Face error")
        card = BJCard(digit: 9, suit: .Club)
        XCTAssert(!card.isFaceOrTenCard(), "Digit not Ten or Face error ")
        
        XCTAssertEqualObjects(card.getCardImage(), UIImage(named:  "club-9"), "Get wrong card image.")
        
        var cards = card.generateAPackOfRandCards()
        XCTAssertEqual(cards.count, 52, "generate the wrong number of cards")
    }
    
    func testBJGameModel() {
        var gameModel = BJGameModel()
        var cardNum = gameModel.cards.count
        
        var card = gameModel.nextCard()
        
        XCTAssertEqual(gameModel.cards.count, cardNum - 1, "the number of card is wrong")
        XCTAssertNotNil(card, "the next card is nil")
        
        var playerCardNum = gameModel.playerCards.count
        card = gameModel.nextPlayerCard()
        XCTAssertEqual(gameModel.playerCards.count, playerCardNum + 1, "the number of player's card is wrong")
        XCTAssertNotNil(card, "the next player's card is nil")
        
        var dealerCardNum = gameModel.dealerCards.count
        card = gameModel.nextDealerCard()
        XCTAssertEqual(gameModel.dealerCards.count, dealerCardNum + 1, "the number of dealer's card is wrong")
        XCTAssertNotNil(card, "the next dealer's card is nil")
        
        var suit = BJCard.BJCardSuit.Spade
        var cards = [BJCard(digit: 1, suit: suit), BJCard(digit: 9, suit: suit), BJCard(digit: 1, suit: suit)]
        XCTAssertFalse(gameModel.areCardsBust(cards), "the cards bust incorrectly")
        XCTAssertEqual(gameModel.calculateBestScore(cards), 21, "calculate the wrong score")
        
        cards = [BJCard(digit: 10, suit: suit), BJCard(digit: 10, suit: suit), BJCard(digit: 2, suit: suit)]
        XCTAssert(gameModel.areCardsBust(cards), "the cards not bust incorrectly")
        XCTAssertEqual(gameModel.calculateBestScore(cards), 0, "calculate the wrong score")
        
        // tesing updating game stage
        //player got 21 points
        gameModel = BJGameModel()
        gameModel.playerCards = [BJCard(digit: 10, suit: suit), BJCard(digit: 1, suit: suit)]
        gameModel.updateGameStage()
        XCTAssertEqual(gameModel.gameStage, .Dealer, "the stage is wrong (should be Dealer stage)")
        
        //player got 5 cards (max)
        gameModel = BJGameModel()
        gameModel.playerCards = [BJCard(digit: 6, suit: suit), BJCard(digit: 1, suit: suit), BJCard(digit: 2, suit: suit), BJCard(digit: 3, suit: suit), BJCard(digit: 5, suit: suit)]
        gameModel.updateGameStage()
        XCTAssertEqual(gameModel.gameStage, .Dealer, "the stage is wrong (should be Dealer stage)")
        
        //player lose
        gameModel = BJGameModel()
        //player' card are bust
        gameModel.playerCards = [BJCard(digit: 9, suit: suit), BJCard(digit: 8, suit: suit), BJCard(digit: 11, suit: suit)]
        gameModel.updateGameStage()
        XCTAssertEqual(gameModel.gameStage, .GameOver, "the stage is wrong (GameOver. Dealer win)")
        XCTAssert(gameModel.didDealerWin, "the stage is wrong (GameOver. Dealer win)")
        
        //player lose
        gameModel = BJGameModel()
        gameModel.gameStage = .Dealer
        // the same score
        gameModel.playerCards = [BJCard(digit: 9, suit: suit), BJCard(digit: 8, suit: suit), BJCard(digit: 3, suit: suit)]
        gameModel.dealerCards = [BJCard(digit: 9, suit: suit), BJCard(digit: 8, suit: suit), BJCard(digit: 3, suit: suit)]
        gameModel.updateGameStage()
        XCTAssertEqual(gameModel.gameStage, .GameOver, "the stage is wrong (GameOver. Dealer win)")
        XCTAssert(gameModel.didDealerWin, "the stage is wrong (GameOver. Dealer win)")
        
        //player lose
        gameModel = BJGameModel()
        gameModel.gameStage = .Dealer
        // dealer score is greater than player's
        gameModel.playerCards = [BJCard(digit: 9, suit: suit), BJCard(digit: 8, suit: suit), BJCard(digit: 1, suit: suit)]
        gameModel.dealerCards = [BJCard(digit: 9, suit: suit), BJCard(digit: 8, suit: suit), BJCard(digit: 3, suit: suit)]
        gameModel.updateGameStage()
        XCTAssertEqual(gameModel.gameStage, .GameOver, "the stage is wrong (GameOver. Dealer win)")
        XCTAssert(gameModel.didDealerWin, "the stage is wrong (GameOver. Dealer win)")
        
        //player lose
        gameModel = BJGameModel()
        gameModel.gameStage = .Dealer
        // dealer score is greater than player's
        gameModel.playerCards = [BJCard(digit: 2, suit: suit), BJCard(digit: 6, suit: suit), BJCard(digit: 1, suit: suit), BJCard(digit: 3, suit: suit), BJCard(digit: 4, suit: suit)]
        gameModel.dealerCards = [BJCard(digit: 9, suit: suit), BJCard(digit: 8, suit: suit), BJCard(digit: 3, suit: suit)]
        gameModel.updateGameStage()
        XCTAssertEqual(gameModel.gameStage, .GameOver, "the stage is wrong (GameOver. Dealer win)")
        XCTAssert(gameModel.didDealerWin, "the stage is wrong (GameOver. Dealer win)")
        
        //player lose
        gameModel = BJGameModel()
        gameModel.gameStage = .Dealer
        // dealer score is greater than player's
        gameModel.playerCards = [BJCard(digit: 2, suit: suit), BJCard(digit: 5, suit: suit), BJCard(digit: 1, suit: suit), BJCard(digit: 3, suit: suit), BJCard(digit: 4, suit: suit)]
        gameModel.dealerCards = [BJCard(digit: 2, suit: suit), BJCard(digit: 6, suit: suit), BJCard(digit: 1, suit: suit), BJCard(digit: 3, suit: suit), BJCard(digit: 4, suit: suit)]
        gameModel.updateGameStage()
        XCTAssertEqual(gameModel.gameStage, .GameOver, "the stage is wrong (GameOver. Dealer win)")
        XCTAssert(gameModel.didDealerWin, "the stage is wrong (GameOver. Dealer win)")
        
        //dealer lose
        gameModel = BJGameModel()
        gameModel.gameStage = .Dealer
        // dealer score is greater than player's
        gameModel.playerCards = [BJCard(digit: 9, suit: suit), BJCard(digit: 8, suit: suit), BJCard(digit: 1, suit: suit)]
        gameModel.dealerCards = [BJCard(digit: 9, suit: suit), BJCard(digit: 8, suit: suit), BJCard(digit: 10, suit: suit)]
        gameModel.updateGameStage()
        XCTAssertEqual(gameModel.gameStage, .GameOver, "the stage is wrong (GameOver. Player win)")
        XCTAssertFalse(gameModel.didDealerWin, "the stage is wrong (GameOver. Player win)")
        
        // game continue
        gameModel = BJGameModel()
        gameModel.gameStage = .Dealer
        // dealer score is greater than player's
        gameModel.playerCards = [BJCard(digit: 9, suit: suit), BJCard(digit: 8, suit: suit), BJCard(digit: 1, suit: suit)]
        gameModel.dealerCards = [BJCard(digit: 9, suit: suit), BJCard(digit: 4, suit: suit), BJCard(digit: 3, suit: suit)]
        gameModel.updateGameStage()
        XCTAssertEqual(gameModel.gameStage, .Dealer, "the stage is wrong (Dealer")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}

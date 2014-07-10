//
//  BJCard.swift
//  BALCK JACK
//
//  Created by 581 on 2014/7/4.
//  Copyright (c) 2014年 581. All rights reserved.
//

//
//  BJCard.h
//  prac7__blackjack
//
//  Created by 581 on 2014/4/14.
//  Copyright (c) 2014年 581. All rights reserved.
//
import Foundation
import UIkit

extension Array {
    
    mutating func shuffle() {
        var count = self.count
        var dupeArr = self.copy()
        count = dupeArr.count
        self.removeAll()
        
        for i in 1..count {
            var nElements = count - i
            var n = Int(arc4random()) % nElements
            self.append(dupeArr[n])
            dupeArr.removeAtIndex(n);
        }
    }
}

class BJCard {
    
    enum BJCardSuit : Int {
        case Club = 1
        case Spade
        case Diamond
        case Heart
        
        init(){
            self = .Club
        }
    }
    
    var suit = BJCardSuit()
    var digit = Int()
    var isFaceUp = Bool()
    
    init(digit: Int, suit: BJCardSuit) {
        self.digit = digit
        self.suit = suit
        self.isFaceUp = false
    }
    
    init() {
        self.digit = -1
    }
    
//    判斷是否為Ace
    func isAnAce() -> Bool{
        if self.digit == 1 {
            return true
        }
        return false
    }
    
//    判斷是否為10以上
    func isFaceOrTenCard() -> Bool {
        if self.digit > 9 {
            return true
        }
        return false
    }
    
    
//    取得點數對應的圖片
    func getCardImage() -> UIImage {
    
        var suit : String;
    
        switch self.suit {
        case .Club:
            suit = "club";
        case .Spade:
            suit = "spade";
        case .Diamond:
            suit = "diamond";
        case .Heart:
            suit = "heart";
        }

        var filename = suit + "-\(self.digit)"
        return UIImage(named: filename)
    }
    
    func generateAPackOfRandCards() -> BJCard[]{
        
        var cards = BJCard[]()
        var card : BJCard
        
        for suit in 1...4 {
            for digit in 1...13 {
                card = BJCard(digit:digit, suit:BJCardSuit.fromRaw(suit)!)
                println(card.suit)
                cards.append(card)
            }
        }
        
        cards.shuffle()
        
        return cards
    }

}


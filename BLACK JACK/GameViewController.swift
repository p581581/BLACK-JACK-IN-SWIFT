//
//  GameViewController.swift
//  BALCK JACK
//
//  Created by 581 on 2014/7/4.
//  Copyright (c) 2014年 581. All rights reserved.
//

import UIKit

class GameViewController: UIViewController{
    
    enum BJGameStage : Int {
        case Player = 1
        case Dealer
        case GameOver
        
        init() {
            self = .Player
        }
    }

    // The dealer's card outlets
    @IBOutlet var dealerCard1 : UIImageView 
    @IBOutlet var dealerCard2 : UIImageView
    @IBOutlet var dealerCard3 : UIImageView
    @IBOutlet var dealerCard4 : UIImageView
    @IBOutlet var dealerCard5 : UIImageView
    
    // The player's card outlets
    @IBOutlet var playerCard1 : UIImageView
    @IBOutlet var playerCard2 : UIImageView
    @IBOutlet var playerCard3 : UIImageView
    @IBOutlet var playerCard4 : UIImageView
    @IBOutlet var playerCard5 : UIImageView
    
    // Button's outlet
    @IBOutlet var hitBtn : UIButton
    @IBOutlet var standBtn : UIButton
    
    // Actions
    @IBAction func hit(sender : AnyObject) {
        println("hit")
        
        // deal the card to Player, and face it up
        var card: BJCard = self.gameModel.nextPlayerCard()
        card.isFaceUp = true
        
        // Update the view and game stage
        renderCards()
        self.gameModel.updateGameStage()
        
        if self.gameModel.isDealerStage() {
            changeDealerTurn()
        }
    }
    
    @IBAction func stand(sender : AnyObject) {
        println("stand")
        
        // change the Game Stage
        self.gameModel.gameStage = .Dealer
        changeDealerTurn();
    }

    // Global var
    var dealerCardViews = UIImageView[]()
    var playerCardViews = UIImageView[]()
    var gameModel: BJGameModel
    
    init(coder aDecoder: NSCoder!) {
        gameModel = BJGameModel()
        super.init(coder: aDecoder)
        
        //add notification
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:"handleNotificationGameDidEnd:",
            name: gameModel.BJNotificationGameDidEnd,
            object: nil
        )

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // init
        dealerCardViews = [dealerCard1, dealerCard2, dealerCard3, dealerCard4, dealerCard5]
        playerCardViews = [playerCard1, playerCard2, playerCard3, playerCard4, playerCard5]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        restartGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderCards() {
        
        // get the max number of card
        var maxCard = self.gameModel.maxPlayerCards;
        var dealerCard, playerCard:BJCard
        var dealerCardView, playerCardView: UIImageView
        
        for i in 0..maxCard {
            dealerCardView = self.dealerCardViews[i]
            playerCardView = self.playerCardViews[i]
            
            dealerCard = self.gameModel.dealerCardAtIndex(i)
            playerCard = self.gameModel.playerCardAtIndex(i)
            
            // if the card's digit equal -1, the card view is invisible
            dealerCardView.hidden = (dealerCard.digit == -1)
            
            // get the card image! if card is not face up, the image is card-back
            if dealerCard.digit != -1 && dealerCard.isFaceUp {
                dealerCardView.image = dealerCard.getCardImage();
            } else{
                dealerCardView.image = UIImage(named:"card-back.png");
            }
            
            // if the card's digit equal -1, the card view is invisible
            playerCardView.hidden = (playerCard.digit == -1);
            
            // get the card image! if card is not face up, the image is card-back
            if playerCard.digit != -1 && playerCard.isFaceUp {
                playerCardView.image = playerCard.getCardImage()
            } else{
                playerCardView.image = UIImage(named:"card-back.png")
            }
        }
    }
    
    func restartGame() {
    
        // reset the game model
        self.gameModel.resetGame()
        var card: BJCard
    
        // deal cards
        card = self.gameModel.nextPlayerCard()
        card.isFaceUp = true
        card = self.gameModel.nextDealerCard()
        card.isFaceUp = true
        card = self.gameModel.nextPlayerCard()
        card.isFaceUp = true
        card = self.gameModel.nextDealerCard()
        
        // Update the View
        renderCards()
        
        // enable the hit and stand button
        self.standBtn.enabled = true
        self.hitBtn.enabled = true
    }
    
    func showSecondDealerCard() {
        
        // show the Second Card, init isn't face up
        var card: BJCard = self.gameModel.lastDealerCard();
        card.isFaceUp = true
        
        // Update the view and game stage
        renderCards()
        self.gameModel.updateGameStage()
        
        if self.gameModel.gameStage != .GameOver {
            // Perform a function after delay
            performWithDelay(0.8, funcName: "showNextDealerCard", withObject: nil)
        }
    }
    
    func showNextDealerCard() {
        // deal the card to Dealer, and face it up
        var card: BJCard = self.gameModel.nextDealerCard()
        card.isFaceUp = true
        
        // Update the view and game stage(controller)
        self.renderCards()
        self.gameModel.updateGameStage()
        
        if self.gameModel.gameStage != .GameOver {
            // Perform a function after delay
            performWithDelay(0.8, funcName: "showNextDealerCard", withObject: nil)
        }
    }
    
    func changeDealerTurn() {
        // lock the button on the view
        self.standBtn.enabled = false;
        self.hitBtn.enabled = false;
        // Perform a function after delay
        performWithDelay(0.8, funcName: "showSecondDealerCard", withObject: nil)
    }

    func handleNotificationGameDidEnd(notification: NSNotification) {
        // Game over
        let didDealerWin: AnyObject! = notification.userInfo["didDealerWin"]
        var message = didDealerWin? as NSObject == 1 ? "Dealer won": "You won"
        
        // Create a UIAlertController to show Game over
        let alc = UIAlertController(
            title: "Game Over",
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        // add button and the handler in alert meesage
        alc.addAction(
            UIAlertAction(
                title: "Back to Menu",
                style: UIAlertActionStyle.Default,
                handler: {alert in
                    // Back to Menu
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            )
        )
        // Change the present view to alert view
        self.presentViewController(alc, animated: true, completion: nil)
    }
    
    func performWithDelay(delay: Double, funcName: String, withObject: AnyObject!) {
        let delay_cal = delay * Double( NSEC_PER_SEC )
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay_cal))
        dispatch_after(time, dispatch_get_main_queue(),{NSThread.detachNewThreadSelector(Selector(funcName), toTarget: self , withObject: withObject)})
    }
    
}


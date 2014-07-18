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
    @IBOutlet var dealerCard1 : UIImageView = nil
    @IBOutlet var dealerCard2 : UIImageView = nil
    @IBOutlet var dealerCard3 : UIImageView = nil
    @IBOutlet var dealerCard4 : UIImageView = nil
    @IBOutlet var dealerCard5 : UIImageView = nil
    
    // The player's card outlets
    @IBOutlet var playerCard1 : UIImageView = nil
    @IBOutlet var playerCard2 : UIImageView = nil
    @IBOutlet var playerCard3 : UIImageView = nil
    @IBOutlet var playerCard4 : UIImageView = nil
    @IBOutlet var playerCard5 : UIImageView = nil
    
    // Button's outlet
    @IBOutlet var hitBtn : UIButton = nil
    @IBOutlet var standBtn : UIButton = nil
    @IBOutlet var betBtn : UIButton = nil
    
    // Actions
    @IBAction func hit(sender : AnyObject) {
        println("hit")
        self.betBtn.enabled = false
        
        // deal the card to Player, and face it up
        var card: BJCard = self.gameModel.nextPlayerCard()
        card.isFaceUp = true
        
        // Update the view and game stage
        renderCards()
        self.gameModel.updateGameStage()
        
        if self.gameModel.gameStage == BJGameModel.BJGameStage.Dealer {
            changeDealerTurn()
        }
    }
    
    @IBAction func stand(sender : AnyObject) {
        println("stand")
        self.betBtn.enabled = false
        
        // change the Game Stage
        self.gameModel.gameStage = .Dealer
        changeDealerTurn();
    }
    
    @IBAction func betting(sender : AnyObject) {
        let bet = betBtn.titleLabel.text.toInt()
        let chips : Int = usrdef.objectForKey("chips") as Int
        
        // check whether the bet is over than the chips value
        if chips >= bet! + 20 {
            betBtn.setTitle( "\(bet! + 20)", forState: .Normal)
        }
    }

    // Global var
    var dealerCardViews = UIImageView[]()
    var playerCardViews = UIImageView[]()
    let usrdef = NSUserDefaults.standardUserDefaults()
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
        let maxCard = self.gameModel.maxPlayerCards;
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
        self.betBtn.enabled = true
        
        // reset the bet
        betBtn.setTitle("20", forState: .Normal)
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
        let cal = betBtn.titleLabel.text.toInt()
        var chips : Int = usrdef.objectForKey("chips") as Int
        var title, message : String
        
        // revise the alert message
        if didDealerWin? as NSObject == 1 {
            title = "Dealer won"
            message = "Sorry ! You lose \(cal) points."
        } else {
            title = "You won"
            message = "Congrats ! You gain \(cal) points."
        }
        
        // Create a UIAlertController to show Game over
        let alc = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        // add button and the handler in alert meesage
        alc.addAction(
            UIAlertAction(
                title: "Menu",
                style: UIAlertActionStyle.Default,
                handler: {alert in
                    // Back to Menu
                    if didDealerWin? as NSObject == 1 {
                        chips -= cal!
                    } else {
                        chips += cal!
                    }
                    self.usrdef.setObject(chips, forKey:"chips")
                    self.usrdef.synchronize()
                    self.dismissViewControllerAnimated(true, completion:nil)
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


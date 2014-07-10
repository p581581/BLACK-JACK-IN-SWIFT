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

//    The dealer's card outlets

    @IBOutlet var dealerCard1 : UIImageView 
    @IBOutlet var dealerCard2 : UIImageView
    @IBOutlet var dealerCard3 : UIImageView
    @IBOutlet var dealerCard4 : UIImageView
    @IBOutlet var dealerCard5 : UIImageView
    
//    The player's card outlets
    @IBOutlet var playerCard1 : UIImageView
    @IBOutlet var playerCard2 : UIImageView
    @IBOutlet var playerCard3 : UIImageView
    @IBOutlet var playerCard4 : UIImageView
    @IBOutlet var playerCard5 : UIImageView
    
//    Button's outlet
    @IBOutlet var hitBtn : UIButton
    @IBOutlet var standBtn : UIButton
    
//    Actions
    @IBAction func hit(sender : AnyObject) {
        println("hit")
        var card: BJCard = self.gameModel.nextPlayerCard()
        card.isFaceUp = true
        
        renderCards()
        
        self.gameModel.updateGameStage()
        if self.gameModel.isDealerStage() {
            playDealerTurn()
        }
    }
    
    @IBAction func stand(sender : AnyObject) {
        println("stand")
        self.gameModel.gameStage = .Dealer
        self.playDealerTurn();
    }

//    Global var
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
        var maxCard = self.gameModel.maxPlayerCards;
        
        var dealerCard, playerCard:BJCard
        var dealerCardView, playerCardView: UIImageView
        
        for i in 0..maxCard {
            dealerCardView = self.dealerCardViews[i]
            playerCardView = self.playerCardViews[i]
            
            dealerCard = self.gameModel.dealerCardAtIndex(i)
            playerCard = self.gameModel.playerCardAtIndex(i)
            
            dealerCardView.hidden = (dealerCard.digit == -1)
            
            if dealerCard.digit != -1 && dealerCard.isFaceUp {
                dealerCardView.image = dealerCard.getCardImage();
            } else{
                dealerCardView.image = UIImage(named:"card-back.png");
            }
            
            playerCardView.hidden = (playerCard.digit == -1);
            
            if playerCard.digit != -1 && playerCard.isFaceUp {
                playerCardView.image = playerCard.getCardImage()
            } else{
                playerCardView.image = UIImage(named:"card-back.png")
            }
        }
    }
    
    func restartGame() {
    
        self.gameModel.resetGame()
        var card: BJCard
    
        card = self.gameModel.nextPlayerCard()
        card.isFaceUp = true
        card = self.gameModel.nextDealerCard()
        card.isFaceUp = true
        card = self.gameModel.nextPlayerCard()
        card.isFaceUp = true
        
        card = self.gameModel.nextDealerCard()
        renderCards()
        
        self.standBtn.enabled = true
        self.hitBtn.enabled = true
    }
    
    func showSecondDealerCard() {
        var card: BJCard = self.gameModel.lastDealerCard();
    
        card.isFaceUp = true
    
        renderCards()
        self.gameModel.updateGameStage()
        if self.gameModel.gameStage != .GameOver {
            
            let delay = 0.8 * Double( NSEC_PER_SEC )
            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(),{NSThread.detachNewThreadSelector(Selector("showNextDealerCard"), toTarget: self , withObject: nil)})
        }
    }
    
    func showNextDealerCard() {
        var card: BJCard = self.gameModel.nextDealerCard()
        card.isFaceUp = true
        self.renderCards()
        self.gameModel.updateGameStage()
        
        if self.gameModel.gameStage != .GameOver {
            
            let delay = 0.8 * Double( NSEC_PER_SEC )
            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(),{NSThread.detachNewThreadSelector(Selector("showNextDealerCard"), toTarget: self , withObject: nil)})
        }
    }
    
    func playDealerTurn() {
        self.standBtn.enabled = false;
        self.hitBtn.enabled = false;
        let delay = 0.8 * Double( NSEC_PER_SEC )
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(),{NSThread.detachNewThreadSelector(Selector("showSecondDealerCard"), toTarget: self , withObject: nil)})
    }

    func handleNotificationGameDidEnd(notification: NSNotification) {
    
        let didDealerWin: AnyObject! = notification.userInfo["didDealerWin"]
        var message = didDealerWin? as NSObject == 1 ? "Dealer won": "You won"
        

        let alc = UIAlertController(
            title: "Game Over",
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        var segue = UIStoryboardSegue(identifier: "backToMenu", source: alc, destination: ViewController())
        
        alc.addAction(
            UIAlertAction(
                title: "Ok",
                style: UIAlertActionStyle.Default,
                handler: {alert in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            )
        )
        self.presentViewController(alc, animated: true, completion: nil)
    }
    
    
}


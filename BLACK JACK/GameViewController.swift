//
//  GameViewController.swift
//  BALCK JACK
//
//  Created by 581 on 2014/7/4.
//  Copyright (c) 2014年 581. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

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
    }
    
    @IBAction func stand(sender : AnyObject) {
        println("stand")
    }

//    Global var
    var dealerCardViews = UIImageView[]()
    var playerCardViews = UIImageView[]()
    var gameModel = BJGameModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


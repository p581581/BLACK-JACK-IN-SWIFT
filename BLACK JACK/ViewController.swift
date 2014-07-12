//
//  ViewController.swift
//  BLACK JACK
//
//  Created by 581 on 2014/7/8.
//  Copyright (c) 2014年 581. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var gameVC : UIViewController? = nil
    let usrdef = NSUserDefaults.standardUserDefaults()
    
    @IBAction func quit(sender : AnyObject) {
        println("quit")
        exit(0)
    }
    
    @IBAction func play(sender : AnyObject) {
        let chips : Int? = usrdef.objectForKey("chips") as? Int
        var vc = gameVC
        
        if chips < 20 {
            vc = UIAlertController(
                title: "You can't play it.",
                message: "Have to buy more chips!",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            (vc as UIAlertController).addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            
            (vc as UIAlertController).addAction(UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default, handler: {alert in self.BuyChip()}))
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func BuyingChips(sender : AnyObject) {
        BuyChip()
    }

    @IBOutlet var chipsLeb : UILabel = nil
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        gameVC =  self.storyboard.instantiateViewControllerWithIdentifier("game") as UIViewController!

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        var chips : AnyObject? = usrdef.objectForKey("chips")
        // init has 60 points
        if chips == nil {
            chips = 60
        }
        usrdef.setObject(chips, forKey:"chips")
        usrdef.synchronize()
        chipsLeb.text = "\(chips)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func BuyChip() {
        // buying chip with 20 points
        let chips : AnyObject? = usrdef.objectForKey("chips") as Int + 20
        usrdef.setObject(chips, forKey:"chips")
        usrdef.synchronize()
        chipsLeb.text = "\(chips)"
    }
}


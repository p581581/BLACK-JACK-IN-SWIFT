//
//  ViewController.swift
//  BLACK JACK
//
//  Created by 581 on 2014/7/8.
//  Copyright (c) 2014年 581. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func quit(sender : AnyObject) {
        println("quit")
        exit(0)
    }
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


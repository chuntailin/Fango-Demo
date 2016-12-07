//
//  LaunchViewController.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/12/6.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        UIView.animateWithDuration(1, delay: 0.5, options: .CurveEaseOut, animations: { 
//            self.logoImageView.alpha = 1
//            }) { (bool) in
//                
//        }
        
        UIView.animateWithDuration(4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.logoImageView.alpha = 1
            }, completion: nil)
    }


}

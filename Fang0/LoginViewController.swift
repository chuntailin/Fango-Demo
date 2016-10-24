//
//  LoginViewController.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/3/23.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

var acceptToken: String!
var fbAccessToken: String!
var userDefaultToken: String?

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var logoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfLogin()
    }
    
    func checkIfLogin() {
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.logoView.hidden = false
        } else {
            self.logoView.hidden = true
            
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends","user_posts", "user_photos"]
            loginView.publishPermissions = ["publish_actions"]
            loginView.delegate = self
            self.view.addSubview(loginView)
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        let fbToken = FBSDKAccessToken.currentAccessToken().tokenString
        NSUserDefaults.standardUserDefaults().setObject(fbToken, forKey: "fbToken")
        
        ServerManager.fbLogin(fbToken: fbToken, complettion: { (user) in
            let userToken = user.userToken
            NSUserDefaults.standardUserDefaults().setObject(userToken, forKey: "token")
        }) { (error) in
            print("Use fbToken to change userToken fail, error: \(error)")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        print("User Logged Out")
    }
}
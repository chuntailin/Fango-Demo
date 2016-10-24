//
//  User.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/10/1.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import Foundation

class User: NSObject {
    
    private var _user_id: Int!
    private var _user_name: String!
    private var _user_token: String!
    
    var userId: Int {
        if _user_id == nil {
            _user_id = 0
        }
        return _user_id
    }
    var userName: String {
        if _user_name == nil {
            _user_name = ""
        }
        return _user_name
    }
    var userToken: String {
        if _user_token == nil {
            _user_token = ""
        }
        return _user_token
    }
    
    init(obj: [String:AnyObject]) {
        self._user_id = obj["id"] as! Int
        self._user_name = obj["name"] as! String
        self._user_token = obj["token"] as! String
    }
}
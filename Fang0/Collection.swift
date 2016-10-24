//
//  Collection.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/10/1.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import Foundation

class Collection: NSObject {
    
    private var _collection_name: String!
    
    var collectionName: String {
        if _collection_name == nil {
            _collection_name = ""
        }
        return _collection_name
    }
    
    
    init(obj: [String:AnyObject]) {
        self._collection_name = obj["collectionname"] as! String
    }
}
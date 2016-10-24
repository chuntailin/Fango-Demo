//
//  Article.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/10/1.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import Foundation

class Article: NSObject {
    
    private var _article_id: String!
    private var _article_content: String!
    private var _article_image_url: String!
    private var _fanpage_name: String!
    private var _fanpage_image_url: String!
    private var _post_time: String!
    
    var articleId: String {
        if _article_id == nil {
            _article_id = ""
        }
        return _article_id
    }
    var articleContent: String {
        if _article_content == nil {
            _article_content = ""
        }
        return _article_content
    }
    var articleImageURL: String {
        if _article_image_url == nil {
            _article_image_url = ""
        }
        return _article_image_url
    }
    var fanpageName: String {
        if _fanpage_name == nil {
            _fanpage_name = ""
        }
        return _fanpage_name
    }
    var fanpageImageURL: String {
        if _article_image_url == nil {
            _fanpage_image_url = ""
        }
        return _fanpage_image_url
    }
    var postTime: String {
        if _post_time == nil {
            _post_time = ""
        }
        return _post_time
    }
    
    
    init(obj: [String:AnyObject]) {
        self._article_id = obj["id"] as! String
        self._article_content = obj["message"] as! String
        self._article_image_url = obj["picture"] as! String
        self._fanpage_name = obj["fanpage_name"] as! String
        self._fanpage_image_url = obj["fanpage_picture"] as! String
        self._post_time = obj["created_time"] as! String
    }
}
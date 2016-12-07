//
//  ServerManager.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/10/1.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager: NSObject {
    
    //MARK: - User
    class func fbLogin(fbToken token: String, complettion:(user: User) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.User(UserAPI.FBLogin(token))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseDictionary = value as? [String:AnyObject] else {
                    print("ServerManager cannot cast fbLogin response to dictionary type")
                    return
                }
                
                let user = User(obj: responseDictionary)
                complettion(user: user)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    
    //MARK: - Article
    class func getArticlesWithTokenAndCategorylist(userToken token: String, categoryList category: String, number num: String, articleSort sort: String, completion:(articles: [Article]) -> Void, failure:(error: NSError?) -> Void ) {
        let api = Router.Article(ArticleAPI.GetArticleWithTokenAndCategorylist(token, category, num, sort))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot cast getArticlesWithTokenAndCategorylist response value to array type")
                    return
                }
                
                var articlesArray = [Article]()
                responseArray.forEach({ (obj) in
                    let article = Article(obj: obj as! [String:AnyObject])
                    articlesArray.append(article)
                })
                completion(articles: articlesArray)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    class func getArticlesWithToken(userToken token: String, number num: String, articleSort sort: String, completion:(articles: [Article]) -> Void, failure:(error: NSError?) -> Void ) {
        let api = Router.Article(ArticleAPI.GetArticleWithToken(token, num, sort))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot cast getArticlesWithToken response value to array type")
                    return
                }
                
                var articlesArray = [Article]()
                responseArray.forEach({ (obj) in
                    let article = Article(obj: obj as! [String:AnyObject])
                    articlesArray.append(article)
                })
                completion(articles: articlesArray)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    class func getArticlesWithCategorylist(categoryList category: String, number num: String, articleSort sort: String, begin: String, completion:(articles: [Article]) -> Void, failure:(error: NSError?) -> Void ) {
        let api = Router.Article(ArticleAPI.GetArticleWithCategorylist(category, num, sort, begin))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot cast getArticlesWithCategorylist response value to array type")
                    return
                }
                
                var articlesArray = [Article]()
                responseArray.forEach({ (obj) in
                    let article = Article(obj: obj as! [String:AnyObject])
                    articlesArray.append(article)
                })
                completion(articles: articlesArray)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    //has problem
    class func searchArticleFromFB(userToken token: String, searchQuery query: String, completion:(articles: [Article]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Article(ArticleAPI.SearchArticleFromFB(token, query))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                print(value)
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot cast searchArticleFromFB response value to array type")
                    return
                }
                
                var articlesArray = [Article]()
                responseArray.forEach({ (obj) in
                    let article = Article(obj: obj as! [String:AnyObject])
                    articlesArray.append(article)
                })
                completion(articles: articlesArray)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    class func searchArticleFromDB(searchQuery query: String, completion:(articles: [Article]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Article(ArticleAPI.SearchArticleFromDB(query))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot cast searchArticleFromDB response value to array type")
                    return
                }
                
                var articlesArray = [Article]()
                responseArray.forEach({ (obj) in
                    let article = Article(obj: obj as! [String:AnyObject])
                    articlesArray.append(article)
                })
                completion(articles: articlesArray)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    
    //MARK: - Collection
    class func getUserCollections(userToken token: String, completion:(collections: [Collection]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Collection(CollectionAPI.GetUserCollections(token))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot cast getuserCollections response value to array type")
                    return
                }
                
                var collectionsArray = [Collection]()
                responseArray.forEach({ (obj) in
                    let collection = Collection(obj: obj as! [String:AnyObject])
                    collectionsArray.append(collection)
                })
                completion(collections: collectionsArray)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    class func getArticlesInCollection(userToken token: String, collectionName name: String, completion:(articles: [Article]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Collection(CollectionAPI.GetArticlesInCollection(token, name))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot case getArticlesInCollection response value to array type")
                    return
                }
                
                var articlesArray = [Article]()
                responseArray.forEach({ (obj) in
                    let article = Article(obj: obj as! [String:AnyObject])
                    articlesArray.append(article)
                })
                completion(articles: articlesArray)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    class func addCollection(userToken token: String, collectionName name: String) {
        let api = Router.Collection(CollectionAPI.AddCollection(token, name))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                print("addCollection Response: \(value)")
            case .Failure(let error):
                print("addCollection Error: \(error)")
            }
        }
    }
    
    class func addArticleToCollection(userToken token: String, collectionName name: String, articleId id: String) {
        let api = Router.Collection(CollectionAPI.AddArticleToCollection(token, name, id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                print("addArticleToCollection Response: \(value)")
            case .Failure(let error):
                print("addArticleToCollection Error: \(error)")
            }
        }
    }
    
    class func deleteCollection(userToken token: String, collectionName name: String) {
        let api = Router.Collection(CollectionAPI.DeleteCollection(token, name))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                print("deleteCollection Response: \(value)")
            case .Failure(let error):
                print("deleteCollection Error: \(error)")
            }
        }
    }
    
    class func deleteArticleInCollection(userToken token: String, collectionName name: String, articleId id: String) {
        let api = Router.Collection(CollectionAPI.DeleteArticleInCollection(token, name, id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                print("deleteArticleInCollection Response: \(value)")
            case .Failure(let error):
                print("deleteArticleInCollection Error: \(error)")
            }
        }
    }
    
    class func getRecommendations(articleId id: String, completion:(articles: [Article]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Recommend(RecommendAPI.GetRecommendations(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot cast getRecommendations response value to array type")
                    return
                }
                
                var articlesArray = [Article]()
                responseArray.forEach({ (obj) in
                    let article = Article(obj: obj as! [String:AnyObject])
                    articlesArray.append(article)
                })
                completion(articles: articlesArray)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    class func rank(userToken token: String, articleId id: String, rankValue value: String) {
        let api = Router.Ranking(RankingAPI.Rank(token, id, value))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                print("rank Response: \(value)")
            case .Failure(let error):
                print("rank Error: \(error)")
            }
        }
    }
}



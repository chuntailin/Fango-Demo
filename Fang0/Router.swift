//
//  Router.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/10/1.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    static let baseURLString = "http://howtofango.redirectme.net:30080"
    
    case User(UserAPI)
    case Article(ArticleAPI)
    case Collection(CollectionAPI)
    case Recommend(RecommendAPI)
    case Ranking(RankingAPI)
    
    var method: Alamofire.Method {
        switch self {
        case .User(let uAPI):
            switch uAPI {
            case .FBLogin(_):
                return .POST
            }
        case .Article(let aAPI):
            switch aAPI {
            case .GetArticleWithTokenAndCategorylist(_, _, _, _):
                return .GET
            case .GetArticleWithToken(_, _, _):
                return .GET
            case .GetArticleWithCategorylist(_, _, _):
                return .GET
            case .SearchArticleFromDB(_):
                return .GET
            case .SearchArticleFromFB(_, _):
                return .GET
            }
        case .Collection(let cAPI):
            switch cAPI {
            case .GetUserCollections(_):
                return .GET
            case .GetArticlesInCollection(_, _):
                return .GET
            case .AddCollection(_, _):
                return .POST
            case .AddArticleToCollection(_, _, _):
                return .POST
            case .DeleteCollection(_, _):
                return .DELETE
            case .DeleteArticleInCollection(_, _, _):
                return .DELETE
            }
        case .Recommend(let rAPI):
            switch rAPI {
            case .GetRecommendations(_):
                return .GET
            }
        case .Ranking(let rAPI):
            switch rAPI {
            case .Rank(_, _, _):
                return .POST
            }
            
        }
    }
    
    var path: String {
        switch self {
        case .User(let uAPI):
            switch uAPI {
            case .FBLogin(_):
                return "/users"
            }
        case .Article(let aAPI):
            switch aAPI {
            case .GetArticleWithTokenAndCategorylist(_, _, _, _):
                return "/articles"
            case .GetArticleWithToken(_, _, _):
                return "/articles"
            case .GetArticleWithCategorylist(_, _, _):
                return "/articles"
            case .SearchArticleFromFB(_, _):
                return "/articles/search?auth=soslab2015"
            case .SearchArticleFromDB(_):
                return "/articles/searchdb"
            }
        case .Collection(let cAPI):
            switch cAPI {
            case .GetUserCollections(_):
                return "/collections"
            case .GetArticlesInCollection(_, _):
                return "/collections/articles"
            case .AddCollection(_, _):
                return "/collections"
            case .AddArticleToCollection(_, _, _):
                return "/collections/articles"
            case .DeleteCollection(_, _):
                return "/collections"
            case .DeleteArticleInCollection(_, _, _):
                return "/collections/articles"
            }
        case .Recommend(let rAPI):
            switch rAPI {
            case .GetRecommendations(_):
                return "/recommendations"
            }
        case .Ranking(let rAPI):
            switch rAPI {
            case .Rank(_, _, _):
                return "/rankings"
            }
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        guard let url = NSURL(string: Router.baseURLString) else {
            fatalError("baseURL cannot cast to url : \(Router.baseURLString)")
        }
        
        let mutableURLRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
        case .User(let uAPI):
            switch uAPI {
            case .FBLogin(let fbToken):
                let params = ["fbtoken":fbToken]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            }
        case .Article(let aAPI):
            switch aAPI {
            case .GetArticleWithTokenAndCategorylist(let token, let categorylist, let number, let sort):
                let params = ["token":token, "categorylist":categorylist, "number":number, "sort":sort]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            case .GetArticleWithToken(let token, let number, let sort):
                let params = ["token":token, "number":number, "sort":sort]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            case .GetArticleWithCategorylist(let categorylist, let number, let sort):
                let params = ["categorylist":categorylist, "number":number, "sort":sort]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            case .SearchArticleFromFB(let token, let query):
                let params = ["token":token, "q":query]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            case .SearchArticleFromDB(let query):
                let params = ["text":query]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            }
        case .Collection(let cAPI):
            switch cAPI {
            case .GetUserCollections(let token):
                let params = ["token":token]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            case .GetArticlesInCollection(let token, let collectionName):
                let params = ["token":token, "collectionname":collectionName]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            case .AddCollection(let token, let collectionName):
                let params = ["token":token, "collectionname":collectionName]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            case .AddArticleToCollection(let token, let collectionName, let articleId):
                let params = ["token":token, "collectionname":collectionName, "articleid":articleId]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            case .DeleteCollection(let token, let collectionName):
                let params = ["token":token, "collectionname":collectionName]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            case .DeleteArticleInCollection(let token, let collectionName, let articleId):
                let params = ["token":token, "collectionname":collectionName, "articleid":articleId]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            }
        case .Recommend(let rAPI):
            switch rAPI {
            case .GetRecommendations(let articleId):
                let params = ["articleid":articleId]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            }
        case .Ranking(let rAPI):
            switch rAPI {
            case .Rank(let token, let articleId, let rankValue):
                let params = ["token":token, "articleid":articleId, "rankvalue":rankValue]
                let request = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                return request
            }
        }
    }
}

enum UserAPI {
    //用FBToken換取Server自定義的token, 參數：fbtoken
    case FBLogin(String)
}

enum ArticleAPI {
    //取得文章, 參數：token, categorylist(可空), number(可空), sort(可空)
    case GetArticleWithTokenAndCategorylist(String, String, String, String)
    //取得文章, 參數：token, number(可空), sort(可空)
    case GetArticleWithToken(String, String, String)
    //取得文章, 參數：categorylist(可空), number(可空), sort(可空)
    case GetArticleWithCategorylist(String, String, String)
    //從FB搜尋文章, 參數：token, q(搜尋字串)
    case SearchArticleFromFB(String, String)
    //從DB搜尋文章, 參數：text(搜尋字串)
    case SearchArticleFromDB(String)
}

enum CollectionAPI {
    //取得使用者的收藏列表, 參數：token
    case GetUserCollections(String)
    //取得收藏列表中的文章, 參數：token, collectionname
    case GetArticlesInCollection(String, String)
    //新增收藏列表, 參數：token, collectionname
    case AddCollection(String, String)
    //新增文章到收藏列表, 參數：token, collectionname, articleid
    case AddArticleToCollection(String, String, String)
    //刪除收藏列表, 參數：token, collectionname
    case DeleteCollection(String, String)
    //刪除收藏列表內的文章, 參數：token, collectionname, articleid
    case DeleteArticleInCollection(String, String, String)
}

enum RecommendAPI {
    //取得文章的其他推薦文章, 參數：articleid
    case GetRecommendations(String)
}

enum RankingAPI {
    //為文章加上評分, 參數：token, articleid, rankvalue
    case Rank(String, String, String)
}

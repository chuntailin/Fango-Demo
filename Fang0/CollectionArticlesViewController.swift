//
//  CollectionArticlesViewController.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/4/6.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire

class CollectionArticlesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collectionArticlesTableView: UITableView!
    
    var selectedCollection: Collection!
    
    var acceptListName: String!
    var collectionArticlesArray = [Article]()
    var idArray = [[String]]()
    
    var sendArticleId = [AnyObject]()
    var sendArticleContent = [AnyObject]()
    var sendArticleImage = [AnyObject]()
    var sendFanspagePictureImage = [AnyObject]()
    var sendPostDateLabel = [AnyObject]()
    var sendFanspageNameLabel = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        if let userToken = NSUserDefaults.standardUserDefaults().valueForKey("token") {
            self.getCollectionArticles(userToken as! String, collectionName: self.selectedCollection.collectionName)
        } else {
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
    }
    
    func initUI() {
        navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.collectionArticlesTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    
    
    //MARK: - HTTP Request
    func getCollectionArticles(userToken: String, collectionName: String){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.getArticlesInCollection(userToken: userToken, collectionName: collectionName, completion: { (articles) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionArticlesArray = articles
                    self.collectionArticlesTableView.reloadData()
                })
            }) { (error) in
                print("get collection articles fail, error: \(error)")
            }
        }
    }
    
    
    
    //MARK: - TableView Delegate and DataSource
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let article = self.collectionArticlesArray[indexPath.row]
            let articleId = article.articleId
            let collectionName = selectedCollection.collectionName
            let userToken = NSUserDefaults.standardUserDefaults().valueForKey("token")
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue, {
                ServerManager.deleteArticleInCollection(userToken: userToken as! String, collectionName: collectionName, articleId: articleId)
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionArticlesArray.removeAtIndex(indexPath.row)
                    self.collectionArticlesTableView.reloadData()
                })
            })
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionArticlesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let article = self.collectionArticlesArray[indexPath.row]
        let cell = self.collectionArticlesTableView.dequeueReusableCellWithIdentifier("collectionArticlesCell") as! CollectionArticlesViewCell
        cell.configCell(article)
        return cell
    }
    
    
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showCollectionArticleDetail"{
            if let indexPath = self.collectionArticlesTableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! ArticleDetailViewController
                let article = self.collectionArticlesArray[indexPath.row]
                
                destinationController.selectedArticle = article
            }
        }
    }
    
}

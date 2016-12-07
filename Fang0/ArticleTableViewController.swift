//
//  ArticleTableViewController.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/20.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire

class ArticleTableViewController: UITableViewController {
    
    
    var selectedIndex: Int!
    var articleDataArray = [Article]()
    var begin = 30
    let refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        getArticlesData("[\(self.selectedIndex)]", number: "10", sort: "new")
    }
    
    func initUI() {
        
        
        self.refreshController.addTarget(self, action: #selector(ArticleTableViewController.uiRefreshControlAction), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshController)
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    
    
    //MARK: - HTTP Reqeust
    func getArticlesData(categorylist: String, number: String, sort: String){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) { 
            ServerManager.getArticlesWithCategorylist(categoryList: categorylist, number: number, articleSort: sort, completion: { (articles) in
                dispatch_async(dispatch_get_main_queue(), { 
                    self.articleDataArray = articles
                    self.tableView.reloadData()
                })
            }) { (error) in
                print("get articles fail, error: \(error)")
            }
        }
    }
    
    func uiRefreshControlAction() {
        begin -= 2
        self.getArticlesData("[\(self.selectedIndex)]", number: "10", sort: "new")
        self.tableView.reloadData()
        refreshController.endRefreshing()
    }
    
    
    //MARK: - Action
    @IBAction func backButtonItemTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    // MARK: - TableView Delegate and DataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleDataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let article = self.articleDataArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell", forIndexPath: indexPath) as! ArticleTableViewCell
        cell.configCell(article)
        return cell
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showArticleDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! ArticleDetailViewController
                destinationController.selectedArticle = self.articleDataArray[indexPath.row]
            }
        }
    }
}

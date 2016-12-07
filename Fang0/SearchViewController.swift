//
//  SearchViewController.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2015/12/22.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!{
        didSet{
            self.loadingIndicator.hidden = true
        }
    }
    
    var searchResultArray = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        searchBar.delegate = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        swipeGesture.direction = .Down
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func tapGesture(sender: UIGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    func swipeGesture(sender: UIGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    
    
    //MARK: - HTTP Request
    func getArticlesData(query: String){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.searchArticleFromDB(searchQuery: query, completion: { (articles) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.searchResultArray = articles
                    self.tableView.reloadData()
                    
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.hidden = true
                })
            }) { (error) in
                print("search article fail, error: \(error)")
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let input = searchBar.text as String!
        
        if input != nil{
            self.loadingIndicator.hidden = false
            self.loadingIndicator.startAnimating()
            self.getArticlesData(input)
            self.searchBar.resignFirstResponder()
        }else{
            let alertVC = UIAlertController(title: "Search Fail!!", message: "There is no article you want ", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "OK", style: .Default, handler: { (_) in })
            alertVC.addAction(confirmAction)
            self.presentViewController(alertVC, animated: true, completion: {
                searchBar.resignFirstResponder()
            })
        }
    }
    
    
    
    // MARK: - TableView Delegate and DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let article = self.searchResultArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell", forIndexPath: indexPath) as! SearchTableViewCell
        cell.configCell(article)
        return cell
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "searchArticleDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let destinationController = segue.destinationViewController as! ArticleDetailViewController
                destinationController.selectedArticle = self.searchResultArray[indexPath.row]
            }
        }
    }
}

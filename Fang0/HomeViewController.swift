//
//  HomeViewController.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/19.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var newCollectionView: UICollectionView!
    @IBOutlet weak var hotCollectionView: UICollectionView!
    
    var newArticlesArray = [Article]()
    var hotArticlesArray = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        initUI()
        
        getHotAndNewArticles("[]", number: "10", begin: "10")
    }
    
    func initUI() {
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1)
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 200
        }
    }
    
    
    //MARK: - HTTP Request
    func getHotAndNewArticles(categorylist: String, number: String, begin: String) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.getArticlesWithCategorylist(categoryList: categorylist, number: number, articleSort: "hot", begin: begin, completion: { (articles) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.hotArticlesArray = articles
                    self.hotCollectionView.reloadData()
                })
            }) { (error) in
                print("get hot articles fail, error: \(error)")
            }
        }
        
        dispatch_async(queue) {
            ServerManager.getArticlesWithCategorylist(categoryList: categorylist, number: number, articleSort: "new", begin: begin, completion: { (articles) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.newArticlesArray = articles
                    self.newCollectionView.reloadData()
                })
            }) { (error) in
                print("get new articles fail, error: \(error)")
            }
        }

        
    }
    
    
    
    //MARK: - CollectionView Delegate and Datesource    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int?
        
        if collectionView == newCollectionView {
            count = self.newArticlesArray.count
        }
        
        if collectionView == hotCollectionView {
            count = self.hotArticlesArray.count
        }
        
        return count!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        if collectionView == self.newCollectionView {
            let newArticle = self.newArticlesArray[indexPath.row]
            let newCell = collectionView.dequeueReusableCellWithReuseIdentifier("newCollectionCell", forIndexPath: indexPath) as! HomeNewCollectionViewCell
            newCell.configCell(newArticle)
            
            cell = newCell 
        }
        
        if collectionView == self.hotCollectionView {
            let hotArticle = self.hotArticlesArray[indexPath.row]
            let hotCell =
                collectionView.dequeueReusableCellWithReuseIdentifier("hotCollectionCell", forIndexPath: indexPath) as! HomeHotCollectionViewCell
            hotCell.configCell(hotArticle)
            cell = hotCell
        }
        
        return cell!
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showNewArticleDetail" {
            let newCell = sender as! HomeNewCollectionViewCell
            let newIndexPath = self.newCollectionView.indexPathForCell(newCell)
            let destinationController = segue.destinationViewController as! ArticleDetailViewController
            
            destinationController.selectedArticle = self.newArticlesArray[newIndexPath!.row]
        }
        
        if segue.identifier == "showHotArticleDetail"{
            let hotCell = sender as! HomeHotCollectionViewCell
            let hotIndexPath = self.hotCollectionView.indexPathForCell(hotCell)
            let destinationController = segue.destinationViewController as! ArticleDetailViewController
            
            destinationController.selectedArticle = self.hotArticlesArray[hotIndexPath!.row]
        }
        
    }
}

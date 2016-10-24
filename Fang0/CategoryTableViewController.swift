//
//  CategoryTableViewController.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/19.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var click = true
    var categoryName = ["  社 會 Society ","  體 育 Sports ","  旅 遊 Travel ","  美 食 Food ","  資 訊 / 科 學 Information / Science ","  遊 戲 Game ","  健 康 / 生 活 Health / Life ","  藝 術 / 設 計 Art / Design ","  媒 體 / 出 版 News ","  影 視 娛 樂 Entertainment ","  交 通 Traffic ","  商 業 Business ","  其 他 Other "]
    var categoryImage = ["society.png","sports.jpg","travel.jpg","food.jpeg","informationscience.jpg","games.jpg","health.png","art.png","literature.png","entertainment.jpg","traffic.jpg","business.jpg","other.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 200
        }
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    
    
    //MARK: - Action
    func searchTapped(sender:UIButton) {
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.tableView.bounds
        self.tableView.addSubview(blurView)
    }
    
    
    
    // MARK: - TableView Delegate and DataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryName.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! CategoryTableViewCell
        cell.categoryLabel.text = categoryName[indexPath.row]
        cell.categoryImageView.image = UIImage(named: categoryImage[indexPath.row])
        return cell
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showArticle"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let destinationController = segue.destinationViewController as! ArticleTableViewController
                
                destinationController.selectedIndex = indexPath.row + 1 as Int
            }
        }
        
    }
}




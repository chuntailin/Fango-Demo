//
//  CollectionViewController.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/19.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addListButton: UIBarButtonItem!
    @IBOutlet weak var editListBatton: UIBarButtonItem!
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var nodataImage: UIImageView!
    @IBOutlet weak var nodataLabel: UILabel!
    @IBOutlet weak var nodataView: UIView!

    var collectionListArray = [Collection]()
    var collectionImageData = ["collection1-1","collection2-1","collection3-1","collection4-1","collection5-1","collection6-1","collection7-1","collection8-1","collection9-1","collection10-1","collection11-1","collection12-1","collection13-1","collection14-1","collection15-1","collection16-1","collection17-1","collection18-1","collection19-1","collection20-1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        if let userToken = NSUserDefaults.standardUserDefaults().valueForKey("token") {
            self.getCollectionList(userToken as! String)
        } else {
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
    }
    
    func initUI() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 200
        }
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    
    
    //MARK: - HTTP Request
    func getCollectionList(userToken: String) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.getUserCollections(userToken: userToken, completion: { (collections) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionListArray = collections
                    self.collectionVIew.reloadData()
                    self.nodataView.hidden = true
                })
            }) { (error) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.addSubview(self.nodataView)
                    self.nodataView.addSubview(self.nodataImage)
                    self.nodataView.addSubview(self.nodataLabel)
                    self.nodataView.hidden = false
                    print("get collections fail, error: \(error)")
                })
            }
        }
    }
    
    func addCollectionList(userToken: String, collectionName: String, completion:() -> Void) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.addCollection(userToken: userToken, collectionName: collectionName)
        }
        completion()
    }
    
    
    
    //MARK: - Action
    @IBAction func editButtonTouched(sender: AnyObject) {
        if self.editListBatton.title == "Edit" {
            self.editListBatton.title = "Done"
            
            for item in self.collectionVIew.visibleCells() {
                let indexPath :NSIndexPath = self.collectionVIew.indexPathForCell(item)!
                let cell = self.collectionVIew.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
                cell.deleteButton.hidden = false
            }
        } else {
            let userToken = NSUserDefaults.standardUserDefaults().valueForKey("token")
            self.editListBatton.title = "Edit"
            self.getCollectionList(userToken as! String)
            if collectionListArray.count == 0 {
                self.collectionVIew.reloadData()
                self.nodataView.hidden = false
            }
        }
    }
    
    @IBAction func addListButtonTouched(sender: AnyObject) {
        let userToken = NSUserDefaults.standardUserDefaults().valueForKey("token")
        
        let alertController = UIAlertController(title: "New Collection", message: "Enter collection name", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
            if let collectionName = alertController.textFields![0].text  {
                self.addCollectionList(userToken as! String, collectionName: collectionName, completion: {
                    self.getCollectionList(userToken as! String)
                    self.collectionVIew.reloadData()
                })
            } else {
                return
            }
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Collection Name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK: - TextField Delegate
    func configurationTextField (textField :UITextField!) {
        textField.placeholder = "Enter collection name"
    }
    
    
    
    //MARK: - CollectionView Delegate and DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionListArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collection = self.collectionListArray[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Collection Cell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.listnameLabel.text = collection.collectionName
        cell.collectionImage.image = UIImage(named: collectionImageData[indexPath.row])
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteButton.addTarget(self, action: #selector(CollectionViewController.deleteCell(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        if self.editListBatton.title == "Edit" {
            cell.deleteButton.hidden = true
        } else {
            cell.deleteButton.hidden = false
        }
        return cell
    }
    
    func deleteCell(sender: UIButton) {
        let userToken = NSUserDefaults.standardUserDefaults().valueForKey("token")
        let i = sender.layer.valueForKey("index") as! Int
        let collection = self.collectionListArray[i]
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.deleteCollection(userToken: userToken as! String, collectionName: collection.collectionName)
            dispatch_async(dispatch_get_main_queue(), { 
                self.collectionListArray.removeAtIndex(i)
                self.collectionVIew.reloadData()
            })
        }
    }
    
    
    
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCollectionArticles" {
            let destinationVC = segue.destinationViewController as! CollectionArticlesViewController
            let cell = sender as! CollectionViewCell
            let indexPath = self.collectionVIew.indexPathForCell(cell)
            let collection = self.collectionListArray[indexPath!.row]
            
            destinationVC.selectedCollection = collection
        }
    }
}

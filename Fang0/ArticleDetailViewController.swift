//
//  ArticleDetailViewController.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/20.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire
import Social
import Cosmos

class ArticleDetailViewController: UIViewController, UIPopoverPresentationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var articleContent: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var fanspagePictureImage: UIImageView!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var fanspageNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var ratingStarView: CosmosView!
    @IBOutlet weak var containViewHeightConstraint: NSLayoutConstraint!
    
    var selectedArticle: Article!
    var recommendArticlesArray = [Article]()
    var pickerItemArray = [Collection]()
    var isPickerViewHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getRecommendArticle(selectedArticle.articleId)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(ArticleDetailViewController.toolBarCancelButton))
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ArticleDetailViewController.toolBarDoneButton))
        
        toolBar.setItems([cancelButton, space, doneButton], animated: true)
        toolBar.userInteractionEnabled = true
        
        
        
        ratingStarView.settings.fillMode = .Full
        ratingStarView.didTouchCosmos = { rating in
            if let userToken =  NSUserDefaults.standardUserDefaults().valueForKey("token") {
                ServerManager.rank(userToken: userToken as! String, articleId: self.selectedArticle.articleId, rankValue: String(rating))
                
                let alertVC = UIAlertController(title: "Success", message: "You have completed ranking the article.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                
                alertVC.addAction(okAction)
                self.presentViewController(alertVC, animated: true, completion: nil)
            } else {
                self.ratingStarView.rating = 0
                
                let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     
        initUI()
    }
    
    func initUI() {
        navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        let articleImageURLString = selectedArticle.articleImageURL
        let articleImageURL = NSURL(string: articleImageURLString)
        let articleImageData = NSData(contentsOfURL: articleImageURL!)
        let articleImage = UIImage(data: articleImageData!)
        
        let fanpageImageURLString = selectedArticle.fanpageImageURL
        let fanpageImageURL = NSURL(string: fanpageImageURLString)
        let fanpageImageData = NSData(contentsOfURL: fanpageImageURL!)
        let fanpageImage = UIImage(data: fanpageImageData!)
        
        self.articleContent.text = selectedArticle.articleContent
        self.articleImage.image = articleImage
        self.postDateLabel.text = selectedArticle.postTime
        self.fanspageNameLabel.text = selectedArticle.fanpageName
        self.fanspagePictureImage.image = fanpageImage
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.hidden = true
        
        self.articleContent.sizeToFit()
        let contentLabelHeight = self.articleContent.frame.height
        self.containViewHeightConstraint.constant = 518 + contentLabelHeight
    }
    
    func toolBarCancelButton() {
        self.pickerView.hidden = true
    }
    
    func toolBarDoneButton() {
        let collection22 = pickerView.selectedRowInComponent(0)
        print("!@%#$@$", collection22)
    }
    
    
    
    
    //MARK: - HTTP Request
    func getRecommendArticle(articleId: String) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.getRecommendations(articleId: articleId, completion: { (articles) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.recommendArticlesArray = articles
                    self.recommendCollectionView.reloadData()
                })
            }) { (error) in
                print("get recommend article fail, error: \(error)")
            }
        }
    }
    
    func getCollectionList(userToken: String, completion:() -> Void){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.getUserCollections(userToken: userToken, completion: { (collections) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.pickerItemArray = collections
                    self.pickerView.reloadAllComponents()
                    completion()
                })
            }) { (error) in
                print("get collections fail, error: \(error)")
            }
        }
    }
    
    
    
    //MARK: - Action
    @IBAction func shareToFacebook(sender: AnyObject) {
        let shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.setInitialText(self.articleContent.text)
        shareToFacebook.addImage(self.articleImage.image)
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTouched(sender: AnyObject) {
        if let userToken = NSUserDefaults.standardUserDefaults().valueForKey("token") {
            let alertController = UIAlertController(title: "New Collection", message: "Enter collection name", preferredStyle: .Alert)
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Collection Name"
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
            let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
                if let collectionName = alertController.textFields![0].text {
                    ServerManager.addCollection(userToken: userToken as! String, collectionName: collectionName)
                } else {
                    return
                }
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func collectionButtonTouched(sender: AnyObject) {
        if let userToken = NSUserDefaults.standardUserDefaults().valueForKey("token") {
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue, {
                self.getCollectionList(userToken as! String, completion: {
                    dispatch_async(dispatch_get_main_queue(), {
                        print("pickerColection", self.pickerItemArray)
                        if self.pickerItemArray != [] {
                            if self.isPickerViewHidden {
                                self.pickerView.hidden = false
                                self.isPickerViewHidden = false
                            } else {
                                self.pickerView.hidden = true
                                self.isPickerViewHidden = true
                            }
                        } else {
                            let alertController = UIAlertController(title: "Reminder", message: "There isn't any collection in your account", preferredStyle: .Alert)
                            let confirmlAction = UIAlertAction(title: "Comfirm", style: .Default) { (_) in}
                            alertController.addAction(confirmlAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    })
                })
            })
        } else {
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - PickerView Delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItemArray.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let collection = self.pickerItemArray[row]
        let collectionName = collection.collectionName
        let pickerViewTitle = NSAttributedString(string: collectionName, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!, NSForegroundColorAttributeName:UIColor.whiteColor()])
        return pickerViewTitle
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let collection = self.pickerItemArray[row]
        let collectionName = collection.collectionName
        
        if let userToken = NSUserDefaults.standardUserDefaults().valueForKey("token") {
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue, {
                ServerManager.addArticleToCollection(userToken: userToken as! String, collectionName: collectionName, articleId: self.selectedArticle.articleId)
                dispatch_async(dispatch_get_main_queue(), {
                    let alertVC = UIAlertController(title: "Success", message: "You have collected the article.", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    
                    alertVC.addAction(okAction)
                    self.presentViewController(alertVC, animated: true, completion: nil)
                    
                    pickerView.hidden = true
                })
            })
        }
    }
    
    
    
    //MARK: - TextField Delegate
    func configurationTextField (textField :UITextField!) {
        textField.placeholder = "Enter collection name"
    }
    
    
    
    
    //MARK: - CollectionView Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recommendArticlesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let article = self.recommendArticlesArray[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("recommendCell", forIndexPath: indexPath) as! RecommendCollectionViewCell
        cell.configCell(article)
        return cell
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecommendArticle" {
            let cell = sender as! RecommendCollectionViewCell
            let indexPath = self.recommendCollectionView.indexPathForCell(cell)
            let destinationController = segue.destinationViewController as! ArticleDetailViewController
            
            destinationController.selectedArticle = self.recommendArticlesArray[indexPath!.row]
        }
    }
}


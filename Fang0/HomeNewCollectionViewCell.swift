//
//  HomeNewCollectionViewCell.swift
//  Fang0
//
//  Created by TinaTien on 2016/4/12.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import UIKit
import Haneke

class HomeNewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newArticleTitle: UILabel!
    @IBOutlet weak var newImage: UIImageView!
    
    func configCell(article: Article) {
        let imageURLString = article.articleImageURL
        let imageURL = NSURL(string: imageURLString)
        
        newArticleTitle.text = article.articleContent
        newImage.hnk_setImageFromURL(imageURL!)
    }
}

//
//  HomeHotCollectionViewCell.swift
//  Fang0
//
//  Created by TinaTien on 2016/4/12.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import UIKit
import Haneke

class HomeHotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hotArticleTitle: UILabel!
    @IBOutlet weak var hotImage: UIImageView!
    
    func configCell(article: Article) {
        let imageURLString = article.articleImageURL
        let imageURL = NSURL(string: imageURLString)
        
        hotArticleTitle.text = article.articleContent
        hotImage.hnk_setImageFromURL(imageURL!)
    }
}

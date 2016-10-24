//
//  CollectionArticlesViewCell.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/4/6.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import UIKit
import Haneke

class CollectionArticlesViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(article: Article) {
        let imageURLString = article.articleImageURL
        let imageURL = NSURL(string: imageURLString)
        
        articleNameLabel.text = article.articleContent
        articleImageView.hnk_setImageFromURL(imageURL!)
    }

}

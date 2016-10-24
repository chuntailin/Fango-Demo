//
//  ArticleTableViewCell.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/20.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Haneke

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(article: Article) {
        let imageURLString = article.articleImageURL
        let imageURL = NSURL(string: imageURLString)
        
        articleContent.text = article.articleContent
        articleImage.hnk_setImageFromURL(imageURL!)
    }
}

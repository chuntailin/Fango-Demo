//
//  SearchTableViewCell.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/23.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Haneke

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var articleContent: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
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

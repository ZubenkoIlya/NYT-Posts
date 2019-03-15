//
//  PostTableViewCell.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 12.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageViewCell: UIImageView!
    @IBOutlet weak var articleTitleView: UIView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAbstractLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        articleTitleView.layer.cornerRadius = 5
        articleTitleView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

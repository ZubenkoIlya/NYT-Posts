//
//  ArticleView.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 12.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import Foundation
import UIKit

protocol ArticleViewDelegate:class {
    func addedFavorites()
    func showFullArticle(post: Post, image: UIImage)
    func cancelButtonAction()
}

class ArticleView: UIView {
    
    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var toFavoriteBarButtonItem:UIBarButtonItem!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAbstractLabel: UILabel!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    weak var delegate: ArticleViewDelegate?
    
    var postItem: Post?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        articleView.layer.cornerRadius = 8
        articleView.layer.masksToBounds = true
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.addGestureRecognizer(swipeDown)
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        self.delegate?.cancelButtonAction()
        closeView()
    }
    
    @IBAction func toFavoritesBarButtonAction(_ sender: UIBarButtonItem) {
        if postItem!.isFavorite != true {
            sender.isEnabled = false
            
            NewsPostCoreDataManager.shared.saveImageOnDevice(image: articleImageView!.image!) { (imagePath) in
                NewsPostCoreDataManager.shared.savePostToCoreData(post: postItem!, imagePath: imagePath, closure: {
                    self.delegate?.addedFavorites()
                })
            }
        } else {
            print("Some error in the ArticleView")
        }
    }
    
    @IBAction func fullArticleBarButtonAction(_ sender: UIBarButtonItem) {
        self.delegate?.cancelButtonAction()
        
        self.delegate?.showFullArticle(post: postItem!, image: articleImageView.image!)
        
        closeView()
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.delegate?.cancelButtonAction()
        closeView()
    }
    
    func closeView() {
        toFavoriteBarButtonItem.isEnabled = true
    }
    
}

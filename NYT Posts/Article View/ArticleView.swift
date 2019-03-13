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
    func toFavorites(emailedPost: EmailedNewsPost?, sharedPost: SharedNewsPost?, viewedPost: ViewedNewsPost?)
    func showFullArticle(title: String, webLink: String, image: UIImage, abstract: String)
    func cancelButtonAction()
}

class ArticleView: UIView {
    
    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var toFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var toFavoriteBarButtonItem:UIBarButtonItem!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAbstractLabel: UILabel!
    
    weak var delegate: ArticleViewDelegate?
    
    var emailedItem: EmailedNewsPost?
    var viewedItem: ViewedNewsPost?
    var sharedItem: SharedNewsPost?
    var favoriteItem: FavoritePost?
    
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
        if emailedItem != nil {
            self.delegate?.toFavorites(emailedPost: emailedItem, sharedPost: nil, viewedPost: nil)
            sender.isEnabled = false
        } else if viewedItem != nil {
            self.delegate?.toFavorites(emailedPost: nil, sharedPost: nil, viewedPost: viewedItem)
            sender.isEnabled = false
        } else if sharedItem != nil {
            self.delegate?.toFavorites(emailedPost: nil, sharedPost: sharedItem, viewedPost: nil)
            sender.isEnabled = false
        } else {
            print("Some error in the ArticleView")
        }
    }
    
    @IBAction func fullArticleBarButtonAction(_ sender: UIBarButtonItem) {
        self.delegate?.cancelButtonAction()
        
        if emailedItem != nil {
            self.delegate?.showFullArticle(title: emailedItem!.title, webLink: emailedItem!.url, image: articleImageView.image!, abstract: emailedItem!.abstract)
        } else if viewedItem != nil {
            self.delegate?.showFullArticle(title: viewedItem!.title, webLink: viewedItem!.url, image: articleImageView.image!, abstract: viewedItem!.abstract)
        } else if sharedItem != nil {
            self.delegate?.showFullArticle(title: sharedItem!.title, webLink: sharedItem!.url, image: articleImageView.image!, abstract: sharedItem!.abstract)
        } else if favoriteItem != nil {
            self.delegate?.showFullArticle(title: favoriteItem!.title!, webLink: favoriteItem!.webLink!, image: articleImageView.image!, abstract: favoriteItem!.abstract!)
        }
        
        closeView()
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.delegate?.cancelButtonAction()
        closeView()
    }
    
    func closeView() {
        emailedItem = nil
        viewedItem = nil
        sharedItem = nil
        favoriteItem = nil
        toFavoriteBarButtonItem.isEnabled = true
    }
    
}

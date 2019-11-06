//
//  ViewController.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 11.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import UIKit
import PageMenu

class MainViewController: UIViewController, CAPSPageMenuDelegate, PostsTableViewControllerDelegate, ArticleViewDelegate {

    var articleView: ArticleView = ArticleView()
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter", size: 20)!]
        self.title = "The New York Times"
        
        NewsPostCoreDataManager.shared.getFavoriteDataFromCoreData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var controllerArray : [UIViewController] = []
        
        let mostEmailedController = PostsTableViewController()
        mostEmailedController.title = "Most emailed"
        mostEmailedController.typeOfTableView = .Emailed
        mostEmailedController.delegate = self
        controllerArray.append(mostEmailedController)
        
        let mostSharedController = PostsTableViewController()
        mostSharedController.title = "Most shared"
        mostSharedController.typeOfTableView = .Shared
        mostSharedController.delegate = self
        controllerArray.append(mostSharedController)
        
        let mostViewedController = PostsTableViewController()
        mostViewedController.title = "Most viewed"
        mostViewedController.typeOfTableView = .Viewed
        mostViewedController.delegate = self
        controllerArray.append(mostViewedController)
        
        let favoritePostsController = PostsTableViewController()
        favoritePostsController.title = "Favorite"
        favoritePostsController.typeOfTableView = .Favorite
        favoritePostsController.delegate = self
        controllerArray.append(favoritePostsController)
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor(red: 63.0/255.0, green: 46.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .viewBackgroundColor(UIColor(red: 53.0/255.0, green: 36.0/255.0, blue: 70.0/255.0, alpha: 1.0)),
            .selectionIndicatorColor(UIColor.orange),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .menuHeight(40.0),
            .menuItemWidth(90.0),
            .centerMenuItems(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        pageMenu!.delegate = self
        self.view.addSubview(pageMenu!.view)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        articleView = Bundle.main.loadNibNamed("ArticleView", owner: nil, options: nil)!.first as! ArticleView
        articleView.delegate = self
        articleView.frame.size.height = (self.navigationController?.view.frame.height)!
        articleView.frame.size.width = (self.navigationController?.view.frame.width)!
        self.navigationController?.view.addSubview(articleView)
        articleView.center = CGPoint(x: (self.navigationController?.view.center.x)!, y: (self.navigationController?.view.center.y)!*3)
        self.articleView.visualEffectView.effect = nil
        articleView.isHidden = true
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int){}
    
    func didMoveToPage(_ controller: UIViewController, index: Int){}
    
    func openArticleView(typeOfTableView: TypeOfPosts, article: Post) {
        
        self.articleView.articleTitleLabel.text = article.title
        self.articleView.articleAbstractLabel.text = article.abstract
        self.articleView.postItem = article
        self.articleView.toFavoriteBarButtonItem.isEnabled = true
        
        if typeOfTableView != TypeOfPosts.Favorite {
            if article.isFavorite == true {
                self.articleView.toFavoriteBarButtonItem.isEnabled = false
            }
            self.articleView.articleImageView.af_setImage(
                withURL: URL(string: article.imageURL!)!,
                placeholderImage: UIImage(named:"placeholder"),
                filter: nil,
                imageTransition: .crossDissolve(0.5),
                completion: { response in })
        } else {
            self.articleView.toFavoriteBarButtonItem.isEnabled = false
            self.articleView.articleImageView.image = NewsPostCoreDataManager.shared.getImageFromDevice(imagePath: article.imageURL!)
        }
        
        DispatchQueue.main.async {
            self.articleView.isHidden = false
            self.articleView.visualEffectView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.articleView.visualEffectView.effect = UIBlurEffect(style: .dark)
                self.articleView.visualEffectView.alpha = 0.8
                self.articleView.center = CGPoint(x: (self.navigationController?.view.center.x)!, y: (self.navigationController?.view.center.y)!)
            })
        }
    }
    
    func addedFavorites() {
        GlobalAlerts.showAlertWithTitleAndAction(self, title: "Favorite", message: "This article added to Favorite folder!", closure: { (result) in })
    }

    func showFullArticle(post: Post, image: UIImage) {
        let webVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleWebView") as? ArticleWebView
        webVC?.articleTitle = post.title
        webVC?.url = post.webLink
        webVC?.post = post
        webVC?.image = image
        self.navigationController?.pushViewController(webVC!, animated: true)
    }
    
    func cancelButtonAction() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.articleView.visualEffectView.effect = nil
                self.articleView.center = CGPoint(x: (self.navigationController?.view.center.x)!, y: (self.navigationController?.view.center.y)!*3)
            }, completion: { (result) in
                self.articleView.isHidden = true
                self.articleView.visualEffectView.isHidden = true
            })
        }
    }
}


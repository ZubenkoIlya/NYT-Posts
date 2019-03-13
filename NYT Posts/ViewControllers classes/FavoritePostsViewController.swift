//
//  FavoritePostsViewController.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 11.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import UIKit

class FavoritePostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticleViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var mainNavigationController: UINavigationController?
    
    var articleView: ArticleView = ArticleView()
    var blurEffect: UIVisualEffectView = UIVisualEffectView()
    
    init() {
        super.init(nibName: "FavoritePostsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        NewsPostCoreDataManager.shared.getFavoriteDataFromCoreData {
            self.tableView.reloadData()
        }
        
        blurEffect.effect = nil
        blurEffect.frame = view.bounds
        blurEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mainNavigationController?.view.addSubview(blurEffect)
        blurEffect.isHidden = true
        
        articleView = Bundle.main.loadNibNamed("ArticleView", owner: nil, options: nil)!.first as! ArticleView
        articleView.delegate = self
        articleView.frame.size.height = (self.mainNavigationController?.view.frame.height)!
        articleView.frame.size.width = (self.mainNavigationController?.view.frame.width)!
        self.mainNavigationController?.view.addSubview(articleView)
        articleView.center = CGPoint(x: (self.mainNavigationController?.view.center.x)!, y: (self.mainNavigationController?.view.center.y)!*4)
        articleView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePostsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        let post = favoritePostsArray[indexPath.row]

        cell.articleTitleLabel.text = post.title
        cell.articleAbstractLabel.text = post.abstract
        cell.articleImageViewCell.image = NewsPostCoreDataManager.shared.getImageFromDevice(imagePath: post.imagePath!)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openArticleView(favorite: favoritePostsArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func openArticleView(favorite: FavoritePost?) {
        if favorite != nil {
            self.articleView.articleImageView.image = NewsPostCoreDataManager.shared.getImageFromDevice(imagePath: (favorite?.imagePath)!)
            self.articleView.articleTitleLabel.text = favorite?.title
            self.articleView.articleAbstractLabel.text = favorite?.abstract
            self.articleView.favoriteItem = favorite
            self.articleView.toFavoriteButton.isEnabled = false
        } else {
            print("Some error in the func openArticleView")
            return
        }
        DispatchQueue.main.async {
            self.blurEffect.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.blurEffect.effect = UIBlurEffect(style: .dark)
                self.blurEffect.alpha = 0.8
                self.articleView.isHidden = false
                self.articleView.center = CGPoint(x: (self.mainNavigationController?.view.center.x)!, y: (self.mainNavigationController?.view.center.y)!)
            })
        }
    }
    
    func toFavorites(emailedPost: EmailedNewsPost?, sharedPost: SharedNewsPost?, viewedPost: ViewedNewsPost?) { }
    
    func showFullArticle(title: String, webLink: String, image: UIImage, abstract: String) {
        let webVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleWebView") as? ArticleWebView
        webVC?.articleTitle = title
        webVC?.url = webLink
        webVC?.abstract = abstract
        webVC?.image = image
        mainNavigationController?.pushViewController(webVC!, animated: true)
    }
    
    func cancelButtonAction() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.articleView.center = CGPoint(x: (self.mainNavigationController?.view.center.x)!, y: (self.mainNavigationController?.view.center.y)!*4)
                self.blurEffect.effect = nil
            }, completion: { (result) in
                self.articleView.isHidden = true
                self.blurEffect.isHidden = true
            })
        }
    }
}

//
//  MostViewedPostsViewController.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 11.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import UIKit

class MostViewedPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticleViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    var mainNavigationController: UINavigationController?
    
    var articleView: ArticleView = ArticleView()
    var blurEffect: UIVisualEffectView = UIVisualEffectView()
    
    init() {
        super.init(nibName: "MostViewedPostsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        NewsPostJSONParser.shared.getMostViewedPosts {
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
        return viewedPostsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        let post = viewedPostsArray[indexPath.row]
        
        cell.articleTitleLabel.text = post.title
        cell.articleAbstractLabel.text = post.abstract
        cell.articleImageViewCell.af_setImage(
            withURL: URL(string: post.url_media_metadata)!,
            placeholderImage: nil,
            filter: nil,
            imageTransition: .crossDissolve(0.5),
            completion: { response in
                viewedPostsArray[indexPath.row].mainImage = response.value!
        })
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openArticleView(viewed: viewedPostsArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func openArticleView(viewed: ViewedNewsPost?) {
        if viewed != nil {
            self.articleView.articleImageView.image = viewed?.mainImage
            self.articleView.articleTitleLabel.text = viewed?.title
            self.articleView.articleAbstractLabel.text = viewed?.abstract
            self.articleView.viewedItem = viewed
            self.articleView.toFavoriteButton.isEnabled = true
            for favoritePost in favoritePostsArray {
                if favoritePost.webLink == viewed?.url {
                    self.articleView.toFavoriteButton.isEnabled = false
                }
            }
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
    
    func toFavorites(emailedPost: EmailedNewsPost?, sharedPost: SharedNewsPost?, viewedPost: ViewedNewsPost?) {
        NewsPostCoreDataManager.shared.saveImageOnDevice(image: viewedPost!.mainImage) { (imagePath) in
            NewsPostCoreDataManager.shared.savePostToCoreData(title: viewedPost!.title, abstract: viewedPost!.abstract, imagePath: imagePath, weblink: viewedPost!.url, closure: {
                GlobalAlerts.showAlertWithTitleAndAction(self, title: "Favorite", message: "This article added to Favorite folder!", closure: { (result) in })
            })
        }
    }
    
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

//
//  MostEmailedPostsViewController.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 11.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import UIKit
import Alamofire

class MostEmailedPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticleViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mainNavigationController: UINavigationController?
    
    var articleView: ArticleView = ArticleView()
    var blurEffect: UIVisualEffectView = UIVisualEffectView()
    
    init() {
        super.init(nibName: "MostEmailedPostsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        NewsPostJSONParser.shared.getMostEmailedPosts {
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailedPostsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        let post = emailedPostsArray[indexPath.row]
        
        cell.articleTitleLabel.text = post.title
        cell.articleAbstractLabel.text = post.abstract
        cell.articleImageViewCell.af_setImage(
            withURL: URL(string: post.url_media_metadata)!,
            placeholderImage: UIImage(named:"placeholder"),
            filter: nil,
            imageTransition: .crossDissolve(0.5),
            completion: { response in
                emailedPostsArray[indexPath.row].mainImage = response.value!
        })
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openArticleView(emailed: emailedPostsArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func openArticleView(emailed: EmailedNewsPost?) {
        if emailed != nil {
            self.articleView.articleImageView.image = emailed?.mainImage
            self.articleView.articleTitleLabel.text = emailed?.title
            self.articleView.articleAbstractLabel.text = emailed?.abstract
            self.articleView.emailedItem = emailed
            self.articleView.toFavoriteButton.isEnabled = true
            for favoritePost in favoritePostsArray {
                if favoritePost.webLink == emailed?.url {
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
        NewsPostCoreDataManager.shared.saveImageOnDevice(image: emailedPost!.mainImage) { (imagePath) in
            NewsPostCoreDataManager.shared.savePostToCoreData(title: emailedPost!.title, abstract: emailedPost!.abstract, imagePath: imagePath, weblink: emailedPost!.url, closure: {
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

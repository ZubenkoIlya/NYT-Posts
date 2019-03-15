//
//  ArticleWebView.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 13.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebView: UIViewController {
    
    @IBOutlet weak var bookmarksButton: UIBarButtonItem!
    @IBOutlet weak var canvasView: UIView!
    
    var webView: WKWebView!
    
    var articleTitle: String?
    var image: UIImage?
    var url: String?
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = articleTitle
        
        self.bookmarksButton.isEnabled = true
        for favoritePost in favoritePostsArray {
            if favoritePost.webLink == self.url {
                self.bookmarksButton.isEnabled = false
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.canvasView.frame.size.width, height: self.canvasView.frame.size.height))
        self.view.addSubview(webView)
        let url = URL(string: self.url!)
        webView.load(URLRequest(url: url!))
    }
    
    @IBAction func addToBookmarksAction(_ sender: UIBarButtonItem) {
        NewsPostCoreDataManager.shared.saveImageOnDevice(image: image!) { (imagePath) in
            NewsPostCoreDataManager.shared.savePostToCoreData(post: post!, imagePath: imagePath, closure: {
                GlobalAlerts.showAlertWithTitleAndAction(self, title: "Favorite", message: "This article added to Favorite folder!", closure: { (result) in
                    self.bookmarksButton.isEnabled = false
                })
            })
        }
    }
    
    @IBAction func refreshPageAction(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
}

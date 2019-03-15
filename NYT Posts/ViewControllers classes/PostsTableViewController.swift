//
//  PostsTableViewController.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 14.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import UIKit
import Alamofire

enum TypeOfPosts {
    case Emailed
    case Shared
    case Viewed
    case Favorite
}

protocol PostsTableViewControllerDelegate: class {
    func openArticleView(typeOfTableView: TypeOfPosts, article: Post)
}

class PostsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: PostsTableViewControllerDelegate?
    
    var newsArray: [Post] = []
    var typeOfTableView: TypeOfPosts = .Emailed
    
    init() {
        super.init(nibName: "MostEmailedPostsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        
         switch typeOfTableView {
         case .Emailed:
            NewsPostJSONParser.shared.getMostEmailedPosts {
                self.newsArray = emailedPostsArray
                self.tableView.reloadData()
            }
         case .Shared:
            NewsPostJSONParser.shared.getMostSharedPosts {
                self.newsArray = sharedPostsArray
                self.tableView.reloadData()
            }
         case .Viewed:
            NewsPostJSONParser.shared.getMostViewedPosts {
                self.newsArray = viewedPostsArray
                self.tableView.reloadData()
         }
         case .Favorite:
            self.newsArray = favoritePostsArray
            self.tableView.reloadData()
         }
 
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if typeOfTableView == TypeOfPosts.Favorite {
            self.newsArray = favoritePostsArray
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        if typeOfTableView != TypeOfPosts.Favorite {
            
            let post = newsArray[indexPath.row]
            cell.articleTitleLabel.text = post.title
            cell.articleAbstractLabel.text = post.abstract
            cell.articleImageViewCell.af_setImage(
            withURL: URL(string: post.imageURL!)!,
            placeholderImage: UIImage(named:"placeholder"),
            filter: nil,
            imageTransition: .crossDissolve(0.5),
            completion: { response in })
            
        } else {
            
            let post = favoritePostsArray[indexPath.row]
            
            cell.articleTitleLabel.text = post.title
            cell.articleAbstractLabel.text = post.abstract
            cell.articleImageViewCell.image = NewsPostCoreDataManager.shared.getImageFromDevice(imagePath: post.imageURL!)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.openArticleView(typeOfTableView: typeOfTableView, article: newsArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

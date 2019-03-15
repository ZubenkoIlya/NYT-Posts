//
//  NewsPostJSONParser.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 11.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import CoreData

var emailedPostsArray: [Post] = []
var sharedPostsArray: [Post] = []
var viewedPostsArray: [Post] = []

class NewsPostJSONParser: NSObject, NSFetchedResultsControllerDelegate {
    
    static let shared = NewsPostJSONParser()
    
    func getMostEmailedPosts(closure: @escaping () -> ()){
        
        let url = "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=\(NYTMostPopularAPIKey)"
        
        Alamofire.request(url).responseJSON { (response) in
            if let data = response.data {
                emailedPostsArray = self.createFrom(data: data)
                closure()
            }
        }
        
    }
    
    func getMostViewedPosts(closure: @escaping () -> ()){
        
        let url = "https://api.nytimes.com/svc/mostpopular/v2/viewed/30.json?api-key=\(NYTMostPopularAPIKey)"
        
        Alamofire.request(url).responseJSON { (response) in
            if let data = response.data {
                viewedPostsArray = self.createFrom(data: data)
                closure()
            }
        }
        
    }
    
    func getMostSharedPosts(closure: @escaping () -> ()){
        
        let url = "https://api.nytimes.com/svc/mostpopular/v2/shared/30/facebook.json?api-key=\(NYTMostPopularAPIKey)"
        
        Alamofire.request(url).responseJSON { (response) in
            if let data = response.data {
                sharedPostsArray = self.createFrom(data: data)
                closure()
            }
        }
        
    }
    
    func createFrom(data: Data) -> [Post] {
        var newsPostsArray: [Post] = []
        
        do {
            let json = try JSON(data: data)
            let jsonPosts = json["results"]
            let jArray = jsonPosts.arrayValue
            
            for post in jArray {
                let url = post["url"].rawString() ?? ""
                let title = post["title"].rawString() ?? ""
                let abstract = post["abstract"].rawString() ?? ""
                //let published_date = post["published_date"].rawString() ?? ""
                
                let media = post["media"].array
                
                let media_metadataArray = media![0]["media-metadata"].array
                var media_metadata: [[String: JSON]] = []
                for element in media_metadataArray! {
                    media_metadata.append(element.dictionary!)
                }
                
                var url_media_metadata = ""
                for element in media_metadata {
                    if element["format"]?.stringValue == "mediumThreeByTwo210" {
                        url_media_metadata = element["url"]!.stringValue
                    }
                }
                
                var isFavorite = false
                for favoritePost in favoritePostsArray {
                    if favoritePost.webLink == url {
                       isFavorite = true
                    }
                }
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Post", in: context)
                let newsPost = Post(entity: entity!, insertInto: nil)
                newsPost.date = Date()
                newsPost.title = title
                newsPost.imageURL = url_media_metadata
                newsPost.abstract = abstract
                newsPost.isFavorite = isFavorite
                newsPost.webLink = url
                newsPostsArray.append(newsPost)
            }
            
            return newsPostsArray
        } catch {
            return newsPostsArray
        }
    }
}

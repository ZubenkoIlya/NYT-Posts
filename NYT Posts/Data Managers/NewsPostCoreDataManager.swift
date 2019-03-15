//
//  NewsPostCoreDataManager.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 12.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var favoritePostsArray: [Post] = []

class NewsPostCoreDataManager: NSObject, NSFetchedResultsControllerDelegate {
    
    static let shared = NewsPostCoreDataManager()
    
    var fetchFavoritePostsResultController: NSFetchedResultsController<Post>!
    
    func getFavoriteDataFromCoreData() {
        favoritePostsArray = []
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchFavoritePostsResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchFavoritePostsResultController.delegate = self
            
            do {
                try fetchFavoritePostsResultController.performFetch()
                if let fetchedObjects = fetchFavoritePostsResultController.fetchedObjects {
                    favoritePostsArray = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }
    
    func saveImageOnDevice(image: UIImage, closure: (String) -> ()) {
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(UUID().uuidString)
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        closure(paths)
    }
    
    func getImageFromDevice(imagePath: String) -> UIImage? {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)
        } else {
            print("Error! Image file not exists")
            return UIImage(named: "placeholder")
        }
    }
    
    func savePostToCoreData(post: Post, imagePath: String, closure: () -> ()) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let postModel = Post(context: appDelegate.persistentContainer.viewContext)
            postModel.date = Date()
            postModel.title = post.title
            postModel.imageURL = imagePath
            postModel.isFavorite = true
            postModel.abstract = post.abstract
            postModel.webLink = post.webLink
            appDelegate.saveContext()
            favoritePostsArray.append(postModel)
            
            favoritePostsArray = favoritePostsArray.sorted(by: {
                $0.date?.compare($1.date!) == .orderedDescending
            })
            
            self.markIsFavorite(post: post)
            
            closure()
        }
    }
    
    func markIsFavorite(post: Post) {
        for emailedPost in emailedPostsArray {
            if emailedPost.webLink == post.webLink {
                emailedPost.isFavorite = true
            }
        }
        
        for viewedPost in viewedPostsArray {
            if viewedPost.webLink == post.webLink {
                viewedPost.isFavorite = true
            }
        }
        
        for sharedPost in sharedPostsArray {
            if sharedPost.webLink == post.webLink {
                sharedPost.isFavorite = true
            }
        }
    }
}








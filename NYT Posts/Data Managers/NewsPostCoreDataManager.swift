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

var favoritePostsArray: [FavoritePost] = []

class NewsPostCoreDataManager: NSObject, NSFetchedResultsControllerDelegate {
    
    static let shared = NewsPostCoreDataManager()
    
    var fetchFavoritePostsResultController: NSFetchedResultsController<FavoritePost>!
    
    func getFavoriteDataFromCoreData(closure: @escaping() -> ()) {
        favoritePostsArray = []
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "addedToFavoriteDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchFavoritePostsResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchFavoritePostsResultController.delegate = self
            
            do {
                try fetchFavoritePostsResultController.performFetch()
                if let fetchedObjects = fetchFavoritePostsResultController.fetchedObjects {
                    favoritePostsArray = fetchedObjects
                    closure()
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
    
    func savePostToCoreData(title: String, abstract: String, imagePath: String, weblink: String, closure: () -> ()) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let postModel = FavoritePost(context: appDelegate.persistentContainer.viewContext)
            postModel.addedToFavoriteDate = Date()
            postModel.title = title
            postModel.imagePath = imagePath
            postModel.abstract = abstract
            postModel.webLink = weblink
            appDelegate.saveContext()
            favoritePostsArray.append(postModel)
            
            favoritePostsArray = favoritePostsArray.sorted(by: {
                $0.addedToFavoriteDate?.compare($1.addedToFavoriteDate!) == .orderedDescending
            })
            
            closure()
        }
    }
}

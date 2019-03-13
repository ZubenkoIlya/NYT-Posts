//
//  ViewController.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 11.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import UIKit
import PageMenu

class MainViewController: UIViewController, CAPSPageMenuDelegate {

    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "AmericanTypewriter", size: 20)!]
        self.title = "The New York Times"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var controllerArray : [UIViewController] = []
        
        let mostEmailedController = MostEmailedPostsViewController()
        mostEmailedController.mainNavigationController = self.navigationController
        mostEmailedController.title = "Most emailed"
        controllerArray.append(mostEmailedController)
        
        let mostSharedController = MostSharedPostsViewController()
        mostSharedController.mainNavigationController = self.navigationController
        mostSharedController.title = "Most shared"
        controllerArray.append(mostSharedController)
        
        let mostViewedController = MostViewedPostsViewController()
        mostViewedController.mainNavigationController = self.navigationController
        mostViewedController.title = "Most viewed"
        controllerArray.append(mostViewedController)
        
        let favoritePostsController = FavoritePostsViewController()
        favoritePostsController.mainNavigationController = self.navigationController
        favoritePostsController.title = "Favorite"
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
    
    func willMoveToPage(_ controller: UIViewController, index: Int){}
    
    func didMoveToPage(_ controller: UIViewController, index: Int){}

}


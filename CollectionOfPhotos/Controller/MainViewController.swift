//
//  MainViewController.swift
//  CollectionOfPhotos
//
//  Created by Алексей Трофимов on 08.06.2022.
//

import UIKit

final class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        
        let imagesVC = ImagesCollectionViewController(collectionViewLayout: WaterfallLayout())
        let favoritesVC = FavoritesTableViewController()
        
        viewControllers = [
            renderNavigationController(viewController: imagesVC, title: "Images", imageName: "photo.circle"),
            renderNavigationController(viewController: favoritesVC, title: "Favorites", imageName: "heart.circle")
        ]
        
    }
    
    private func renderNavigationController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = UIImage(systemName: imageName)
        return navigationVC
    }
    
    
}


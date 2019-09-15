//
//  TabBarController.swift
//  Stitch3D
//
//  Created by You-Wen Ji on 9/13/19.
//  Copyright © 2019 You-Wen Ji. All rights reserved.
//

import UIKit

class TabBarController:UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup view controllers
        let layout = UICollectionViewFlowLayout()
        let folderController = FolderController(collectionViewLayout: layout)
        let recentFolderNavController = UINavigationController(rootViewController: folderController)
        recentFolderNavController.tabBarItem.title = "Library"
        recentFolderNavController.tabBarItem.image = UIImage(named: "bar_Folder")
        
        viewControllers = [
            recentFolderNavController,
            creatNavWithTitle(title:"Compose", imageName: "bar_Edit", viewController: UIViewController()),
            creatNavWithTitle(title:"Joystick", imageName: "bar_Joystick", viewController: JoystickController()),
            creatNavWithTitle(title:"ARDraw", imageName: "bar_AR", viewController: ARDrawingController())
            
        ]
    }
    
    private func creatNavWithTitle(title: String, imageName: String, viewController: UIViewController) -> UINavigationController {
        //let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}

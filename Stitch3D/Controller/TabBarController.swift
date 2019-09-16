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
        let joysStickontroller = JoystickController()
        let recentFolderNavController = UINavigationController(rootViewController: joysStickontroller)
        recentFolderNavController.tabBarItem.title = "Joystick"
        recentFolderNavController.tabBarItem.image = UIImage(named: "bar_Joysitck")
        
        viewControllers = [
            creatNavWithTitle(title:"Joystick", imageName: "bar_Joystick", viewController: JoystickController()),
            creatNavWithTitle(title:"Library", imageName: "bar_Folder", viewController: FolderController(collectionViewLayout: layout)),
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

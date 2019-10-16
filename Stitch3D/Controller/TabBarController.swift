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
        viewControllers = [
            creatNavWithTitle(title:"Joystick", imageName: "bar_Joystick", selected: "joystick_selected", viewController: JoystickController()),
            creatNavWithTitle(title:"Library", imageName: "bar_Folder", selected: "folder_selected", viewController: FolderController(collectionViewLayout: layout)),
            creatNavWithTitle(title:"ARDraw", imageName: "bar_AR", selected: "AR_selected", viewController: ARDrawingController())
        ]

        let selectedColor   = Colors.JFF893B
        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    }
    
    private func creatNavWithTitle(title: String, imageName: String, selected: String,viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.tabBarItem.selectedImage = UIImage(named: selected)
        return navController
    }
}

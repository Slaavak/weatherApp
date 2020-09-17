//
//  TabBarControllerViewController.swift
//  weatherApp
//
//  Created by Slava Korolevich on 9/17/20.
//  Copyright © 2020 Slava Korolevich. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        
        
        
    }
    

      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
//          let icon1 = UITabBarItem(title: "Title", image: UIImage(named: "someImage.png"), selectedImage: UIImage(named: "otherImage.png"))
//
        let firstViewController = ViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let secondViewController = SecondViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        let tabBarList = [firstViewController, secondViewController]
        
        self.viewControllers = tabBarList
        self.selectedIndex = 0 
      }


    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
          return true
      }

}

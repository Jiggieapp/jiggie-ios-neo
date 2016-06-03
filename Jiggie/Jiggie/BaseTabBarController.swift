//
//  BaseTabBarController.swift
//  NyariJob-Pro
//
//  Created by uudshan on 24/03/16.
//  Copyright © 2016 NyariJob. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
    }
    
    static func defaultTabBarController(selected: Int? = 0) -> BaseTabBarController {
        let eventsNavigationController = UINavigationController(rootViewController: UIViewController())
        let socialNavigationController = UINavigationController(rootViewController: UIViewController())
        let chatNavigationController = UINavigationController(rootViewController: UIViewController())
        let moreNavigationController = UINavigationController(rootViewController: UIViewController())
        
        let tabBarController = BaseTabBarController()
        tabBarController.tabBar.translucent = false
        tabBarController.tabBar.tintColor = UIColor.phPurple()
        tabBarController.viewControllers = [eventsNavigationController,
                                            socialNavigationController,
                                            chatNavigationController,
                                            moreNavigationController]
        
        var tabBarItems = tabBarController.tabBar.items as [UITabBarItem]!
        tabBarItems[0].image = UIImage(named: "tab-events-icon")
        tabBarItems[1].image = UIImage(named: "tab-social-icon")
        tabBarItems[2].image = UIImage(named: "tab-chat-icon")
        tabBarItems[3].image = UIImage(named: "tab-more-icon")
        
        tabBarController.selectedIndex = selected!
        
        return tabBarController
    }
    
}

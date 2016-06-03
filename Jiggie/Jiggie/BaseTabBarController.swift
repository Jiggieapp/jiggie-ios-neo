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
        let eventsNavigationController = UINavigationController(rootViewController: EventListViewController())
        let socialNavigationController = UINavigationController(rootViewController: SocialViewController())
        let chatNavigationController = UINavigationController(rootViewController: ChatListViewController())
        let moreNavigationController = UINavigationController(rootViewController: MoreViewController())
        
        let tabBarController = BaseTabBarController()
        tabBarController.tabBar.translucent = false
        tabBarController.tabBar.tintColor = UIColor.phPurple()
        tabBarController.viewControllers = [eventsNavigationController,
                                            socialNavigationController,
                                            chatNavigationController,
                                            moreNavigationController]
        
        let titleTextAttributes = [NSFontAttributeName : UIFont.phBold(11)];
        let titlePosition = UIOffsetMake(0, -3)
        
        var tabBarItems = tabBarController.tabBar.items as [UITabBarItem]!
        tabBarItems[0].image = UIImage(named: "tab-events-icon")
        tabBarItems[0].imageInsets = UIEdgeInsetsMake(0, -0.5, 0, 0.5)
        tabBarItems[0].title = "EVENTS"
        tabBarItems[0].titlePositionAdjustment = titlePosition
        tabBarItems[0].setTitleTextAttributes(titleTextAttributes, forState: .Normal)
        
        tabBarItems[1].image = UIImage(named: "tab-social-icon")
        tabBarItems[1].imageInsets = UIEdgeInsetsMake(0, -2, 0, 2)
        tabBarItems[1].title = "SOCIAL"
        tabBarItems[1].titlePositionAdjustment = titlePosition
        tabBarItems[1].setTitleTextAttributes(titleTextAttributes, forState: .Normal)
        
        tabBarItems[2].image = UIImage(named: "tab-chat-icon")
        tabBarItems[2].title = "CHAT"
        tabBarItems[2].titlePositionAdjustment = titlePosition
        tabBarItems[2].setTitleTextAttributes(titleTextAttributes, forState: .Normal)
        
        tabBarItems[3].image = UIImage(named: "tab-more-icon")
        tabBarItems[3].title = "MORE"
        tabBarItems[3].titlePositionAdjustment = titlePosition
        tabBarItems[3].setTitleTextAttributes(titleTextAttributes, forState: .Normal)
        
        tabBarController.selectedIndex = selected!
        
        return tabBarController
    }
    
}

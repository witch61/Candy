//
//  Common.swift
//  SwiftSideslipLikeQQ
//
//  Created by liuyao on 15/7/1.
//  Copyright (c) 2015年 Sina. All rights reserved.
//

import UIKit
//import Appdelegate

#if (arch(i386) || arch(x86_64)) && os(iOS)
let DEVICE_IS_SIMULATOR = true
#else
    let DEVICE_IS_SIMULATOR = false
#endif

struct Common {

    static let screenWidth = UIScreen.mainScreen().applicationFrame.maxX
    static let screenHeight = UIScreen.mainScreen().applicationFrame.maxY    
    
   static let slideMenuView = UIApplication.sharedApplication().keyWindow?.rootViewController as! SlideMenuView
    
    static let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController//
    static let leftVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftViewController") as! UIViewController

    static let discoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DiscoverList") as! UIViewController
    static let messageListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MessageListViewController") as! ChatListViewController
    static let informationListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("informationList") as! UIViewController

}

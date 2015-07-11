//
//  AppDelegate.swift
//  Candy
//
//  Created by liuyao on 15/6/30.
//  Copyright (c) 2015年 Sina. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , IChatManagerDelegate{

    var window: UIWindow?
    var tabBarVC: MainTabBarController?
    
    var _connectionState: EMConnectionState?
    var  mainController :HomeViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()//设置通用背景颜色
        window?.makeKeyAndVisible()
        
        let tbVC = Common.tabBarVC
        let letfVC = Common.leftVC
        
        tabBarVC = Common.tabBarVC
        var leftSide = Common.leftVC
        var slideMenu = SlideMenuView(rootController: tabBarVC)
        slideMenu?.leftViewController = letfVC
        window?.rootViewController = slideMenu
        
        // 改变 StatusBar 颜色
        application.statusBarStyle = UIStatusBarStyle.LightContent
        
        // 改变 navigation bar 的背景色
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.translucent = false
        navigationBarAppearace.barTintColor = UIColor(hex: 0x25b6ed)
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loginStateChange:"), name: KNOTIFICATION_LOGINCHANGE, object: nil)
        
        // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
        self.easemobApplication(application, didFinishLaunchingWithOptions: launchOptions)
       
        self.loginStateChange(nil)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if tabBarVC != nil {
            tabBarVC?.jumpToChatList()
        }
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if tabBarVC != nil {
            tabBarVC?.didReceiveLocalNotification(notification)
        }

    }
    //MARK: - private
    //登陆状态改变
    func loginStateChange(notification: NSNotification?)
    {
        let isAutoLogin: Bool = EaseMob.sharedInstance().chatManager.isAutoLoginEnabled!
        let loginSuccess = notification?.object?.boolValue as Bool?
        
        if (isAutoLogin || (loginSuccess != nil && loginSuccess!.boolValue)) {
           //加载申请通知的数据  
            ApplyViewController.shareController().loadDataSourceFromLocalDB()
            //    if (_mainController == nil) {
            //    _mainController = [[MainViewController alloc] init];
            //    [_mainController networkChanged:_connectionState];
            //    nav = [[UINavigationController alloc] initWithRootViewController:_mainController];
            //    }else{
            //    nav  = _mainController.navigationController;
            //    }
            //    }else{//登陆失败加载登陆页面控制器
            //    _mainController = nil;
            //    LoginViewController *loginController = [[LoginViewController alloc] init];
            //    nav = [[UINavigationController alloc] initWithRootViewController:loginController];
            //    loginController.title = NSLocalizedString(@"AppName", @"EaseMobDemo");
            //    }
        }
    }

}


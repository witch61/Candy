//
//  AppDelegate+EaseMob.swift
//  Candy
//
//  Created by liuyao on 15/7/1.
//  Copyright (c) 2015年 Sina. All rights reserved.
//

import Foundation

enum ApplyStyle: Int {
    case Friend = 0
    case GroupInvitation
    case JoinGroup
}


/**
*  本类中做了EaseMob初始化和推送等操作
*/
extension AppDelegate {
    func easemobApplication(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?){
        if let launchOptions = launchOptions {
            let userInfo: AnyObject? = launchOptions.valueForKey("UIApplicationLaunchOptionsRemoteNotificationKey")
            if let userInfo: AnyObject = userInfo {
                self.didReceiveRemoteNotification(userInfo as! NSDictionary)
            }
            
        }
        _connectionState = EMConnectionState.eEMConnectionConnected
        self.registerRemoteNotification()
        
        let ud = NSUserDefaults.standardUserDefaults()
        var appkey = ud.stringForKey("identifier_appkey")
        if appkey == nil {
            appkey = "lucy61#candy"
            ud.setObject(appkey, forKey: "identifier_appkey")
        }
        var specifyServer = ud.objectForKey("identifier_enable") as? NSNumber
        if specifyServer == nil {
            specifyServer = NSNumber(bool: false)
            ud.setObject(specifyServer, forKey: "identifier_enable")
        }
        var imServer = ud.stringForKey("identifier_imserver")
        if imServer == nil {
            imServer = "im1.easemob.com"
            ud.setObject(imServer, forKey: "identifier_imserver")
        }
        var imPort = ud.stringForKey("identifier_import")
        if imServer == nil {
            imPort = "443"
            ud.setObject(imPort, forKey: "identifier_import")
        }
        var restServer = ud.stringForKey("identifier_restserver")
        if restServer == nil {
            restServer = "a1.easemob.com"
            ud.setObject(restServer, forKey: "identifier_restserver")
        }
        ud.synchronize()
        
        
        // WARNING: SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
        var apnsCertName:String?
        #if DEBUG
            apnsCertName = "chatdemoui_dev"
            #else
            apnsCertName = "chatdemoui"
            
        #endif
        
        if !(specifyServer!.boolValue)
        {
            EaseMob.sharedInstance().registerSDKWithAppKey(appkey!, apnsCertName: apnsCertName!, otherConfig: [kSDKConfigEnableConsoleLogger:NSNumber(bool: true)])
        }else {
            /*@liuyao registerPrivateServerWithParams没有实现
            //Only for internal use to test
            let dic = [kSDKAppKey:appkey,
                kSDKApnsCertName:apnsCertName,
                kSDKServerApi:restServer,
                kSDKServerChat:imServer,
                kSDKServerGroupDomain:"conference.easemob.com",
                kSDKServerChatDomain:"easemob.com",
                kSDKServerChatPort:imPort]
            let easemob = EaseMob.sharedInstance()
            let selector = Selector("registerPrivateServerWithParams:")
            NSThread.performSelector(selector, withObject: nil, afterDelay: 0)
            */
        }
        
        // 登录成功后，自动去取好友列表
        // SDK获取结束后，会回调
        // - (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error方法。
        // TODO:设置属性还有问题
//                EaseMob.sharedInstance().chatManager.isAutoFetchBuddyList = true
        
        // 注册环信监听
        self.registerRemoteNotification()
//        EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.setupNotifiers()
    }
    
    
    // 监听系统生命周期回调，以便将需要的事件传给SDK
    func setupNotifiers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appDidEnterBackgroundNotif:"), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appWillEnterForeground:"), name:UIApplicationWillEnterForegroundNotification, object:nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appDidFinishLaunching:"), name:UIApplicationDidFinishLaunchingNotification, object:nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appDidBecomeActiveNotif:"), name:UIApplicationDidBecomeActiveNotification, object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appWillResignActiveNotif:"), name:UIApplicationWillResignActiveNotification, object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appDidReceiveMemoryWarning:"), name:UIApplicationDidReceiveMemoryWarningNotification, object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appWillTerminateNotif:"), name:UIApplicationWillTerminateNotification, object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appProtectedDataWillBecomeUnavailableNotif:"), name:UIApplicationProtectedDataWillBecomeUnavailable, object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appProtectedDataDidBecomeAvailableNotif:"), name:UIApplicationProtectedDataDidBecomeAvailable, object:nil)
    }
    
    // MARK: - notifiers
    func appDidEnterBackgroundNotif(notif: NSNotification){
        EaseMob.sharedInstance().applicationDidEnterBackground(notif.object as! UIApplication)
    }
    
    func appWillEnterForeground(notif: NSNotification)
    {
        EaseMob.sharedInstance().applicationWillEnterForeground(notif.object as! UIApplication)
    }
    
    func appDidFinishLaunching(notif: NSNotification)
    {
        EaseMob.sharedInstance().applicationDidFinishLaunching(notif.object as! UIApplication)
    }
    
    func appDidBecomeActiveNotif(notif: NSNotification)
    {
        EaseMob.sharedInstance().applicationDidBecomeActive(notif.object as! UIApplication)
    }
    
    func appWillResignActiveNotif(notif: NSNotification)
    {
        EaseMob.sharedInstance().applicationWillResignActive(notif.object as! UIApplication)
    }
    
    func appDidReceiveMemoryWarning(notif: NSNotification)
    {
        EaseMob.sharedInstance().applicationDidReceiveMemoryWarning(notif.object as! UIApplication)
    }
    
    func appWillTerminateNotif(notif: NSNotification)
    {
        EaseMob.sharedInstance().applicationWillTerminate(notif.object as! UIApplication)
    }
    
    func appProtectedDataWillBecomeUnavailableNotif(notif: NSNotification)
    {
        EaseMob.sharedInstance().applicationProtectedDataWillBecomeUnavailable(notif.object as! UIApplication)
    }
    
    func appProtectedDataDidBecomeAvailableNotif(notif: NSNotification)
    {
        EaseMob.sharedInstance().applicationProtectedDataDidBecomeAvailable(notif.object as! UIApplication)
    }
    
    // 将得到的deviceToken传给SDK
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        EaseMob.sharedInstance().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    // 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        EaseMob.sharedInstance().application(application, didFailToRegisterForRemoteNotificationsWithError: error)
        self.LYAlert("Fail to register apns", message: error.description)
    }
    
    // 注册推送
    func registerRemoteNotification()
    {
        let application = UIApplication.sharedApplication()
        application.applicationIconBadgeNumber = 0
        
        if application.respondsToSelector(Selector("registerUserNotificationSettings:")) {
            let notificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        #if !TARGET_IPHONE_SIMULATOR
        //iOS8 注册APNS
        if application.respondsToSelector(Selector("registerForRemoteNotifications")) {
            application.registerForRemoteNotifications()
        }else {
            let notificationTypes = UIRemoteNotificationType.Alert | UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(notificationTypes)
        }
        #endif
    }
    
    //MARK:  - registerEaseMobNotification
    func registerEaseMobNotification()
    {
        self.unRegisterEaseMobNotification()
        
        // 将self 添加到SDK回调中，以便本类可以收到SDK回调
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
    }
    
    func unRegisterEaseMobNotification(){
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
    }
    
    
    
    //MARK: - IChatManagerDelegate
    // 开始自动登录回调
    func willAutoLoginWithInfo(loginInfo: [NSObject : AnyObject]?, error: EMError?)
    {
        var alertView: UIAlertView
        if let error = error {
            alertView = UIAlertView(title: "Prompt", message: "Automatic logon failure", delegate: nil, cancelButtonTitle: "OK")
            
            //发送自动登陆状态通知
            NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: false)
        }
        else{
            alertView = UIAlertView(title: "Prompt", message: "Start automatic login...", delegate: nil, cancelButtonTitle: "OK")
            
            //将旧版的coredata数据导入新的数据库
            var error = EaseMob.sharedInstance().chatManager.importDataToNewDatabase()
            if error == nil {
                error = EaseMob.sharedInstance().chatManager.loadDataFromDatabase()
            }
        }
        alertView.show()
    }
    
    // 结束自动登录回调
    func didAutoLoginWithInfo(loginInfo: [NSObject : AnyObject]?, error: EMError?)
    {
        var alertView: UIAlertView
        if let error = error {
            alertView = UIAlertView(title: "Prompt", message: "Automatic logon failure", delegate: nil, cancelButtonTitle: "OK")
            
            //发送自动登陆状态通知
            NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: false)
        }
        else{
            EaseMob.sharedInstance().chatManager.asyncFetchMyGroupsList()
            alertView = UIAlertView(title: "Prompt", message: "End automatic login...", delegate: nil, cancelButtonTitle: "OK")

        }
        alertView.show()

    }
    
    // 好友申请回调
    func didReceiveBuddyRequest(username: String?, message: String?)
    {
        if username == nil {
            return
        }
        var messageVar = message
        if message == nil {
            messageVar = "\(username) add you as a friend"
        }
        var dic:[String : AnyObject?] = ["title":username, "username":username, "applyMessage":messageVar, "applyStyle":ApplyStyle.Friend.rawValue]

        //TODO: UI处理
//            [[ApplyViewController shareController] addNewApply:dic];
//            if (self.mainController) {
//            [self.mainController setupUntreatedApplyCount];
//            }
    }
    
    // 离开群组回调
    func group(group: EMGroup, didLeave reason: EMGroupLeaveReason, error: EMError?)
    {
        var tmpStr: NSString? = group.groupSubject
        if !(tmpStr!.length > 0) {
            let groupArray: NSArray? = EaseMob.sharedInstance().chatManager.groupList
            for obj in groupArray! {
                if obj.groupId == group.groupId {
                    tmpStr = obj.groupSubject
                    break
                }
            }
        }
        var str: NSString?
        if reason == EMGroupLeaveReason.eGroupLeaveReason_BeRemoved {
            str = "you have been kicked out from the group of \'\(tmpStr)\'"
        }
        if str!.length > 0 {
            self.LYAlert(str! as String, message: nil)
        }
    }
    
    // 申请加入群组被拒绝回调
    func didReceiveRejectApplyToJoinGroupFrom(fromId: String?, groupname: String?, reason: String?, error: EMError?) {
       var reasonVar = reason
        if reason == nil || reason!.isEmpty {
            reasonVar = "be refused to join the group\'\(groupname)\'"
        }
        self.LYAlert("Prompt", message: reasonVar)
    }
    //接收到入群申请
    func didReceiveApplyToJoinGroup(groupId: String?, groupname:String, applyUsername username: String?, reason: String?, error: EMError?) {
        if let gid = groupId {
            return
        }
        if let name = username {
            return
        }
        var reasonVar = reason
        if reason == nil {
            reasonVar = "\(username) apply to join groups\'\(username)\'"
        }else {
            reasonVar = "\(username) apply to join groups\'\(groupname)\'：\(reason)"
        }
        if let error = error {
            let message = "send application failure:\(reasonVar)\nreason：\(error.description)"
            self.LYAlert("Error", message: message)
        }else {
            let dic :[String: NSString?] = ["title":groupname, "groupId":groupId, "username":username, "groupname":groupname, "applyMessage":reasonVar,"applyStyle":"\(ApplyStyle.JoinGroup)"]
            //    [[ApplyViewController shareController] addNewApply:dic];
            if let m = self.mainController {
                //    [self.mainController setupUntreatedApplyCount];
            }
            
        }
    }
    
    // 已经同意并且加入群组后的回调
    func didAcceptInvitationFromGroup(group: EMGroup, error:EMError?){
        if let e = error {
            return
        }
        var groupTag = group.groupSubject
        if groupTag.isEmpty {
            groupTag = group.groupId
        }
        
        let message = "agreed and joined the group of \(groupTag)"
        self.LYAlert("Prompt", message: message)
        
    }
    
    // 绑定deviceToken回调
    func didBindDeviceWithError(error: EMError?){
        if let name = error {
            self.LYAlert(nil, message: "Fail to bind device token")
        }
    }
    
    
    // 网络状态变化回调
    func didConnectionStateChanged(connectionState: EMConnectionState) {
        _connectionState = connectionState
        //TODO:网络变化时的处理
        //        [self.mainController networkChanged:connectionState];
    }
    
    // 打印收到的apns信息
    func didReceiveRemoteNotification(userInfo: NSDictionary) {
        var parseError: NSError?
        let jsonData = NSJSONSerialization.dataWithJSONObject(userInfo, options: NSJSONWritingOptions.PrettyPrinted, error: &parseError)
        let str: String = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String
        
        //alert
        self.LYAlert("Apns content", message: str)
    }
    
    func LYAlert(title: String? ,message: String?){
        let sysVersionInt = (UIDevice.currentDevice().systemVersion as NSString).integerValue
        if sysVersionInt > 8 {
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(defaultAction)
            
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }else {
            let alert: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }
    }
    
}

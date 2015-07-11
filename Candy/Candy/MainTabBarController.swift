//
//  MainTabBarController.swift
//  Candy
//
//  Created by liuyao on 15/7/1.
//  Copyright (c) 2015年 Sina. All rights reserved.
//

import UIKit
//两次提示的默认间隔
 let kDefaultPlaySoundInterval = 3.0;
 let kMessageType = "MessageType"
 let kConversationChatter = "ConversationChatter";
 let kGroupName = "GroupName";

class MainTabBarController: UITabBarController, IChatManagerDelegate, EMCallManagerDelegate {
    var lastPlaySoundDate: NSDate?;
    var connectionState: EMConnectionState = EMConnectionState.eEMConnectionDisconnected
    let chatListVC: ChatListViewController = Common.messageListVC

    override func viewDidLoad() {
        super.viewDidLoad()
        
        EaseMob.sharedInstance().chatManager.asyncLoginWithUsername("lucy1", password: "witch1210", completion: {
            (loginInfo, error) -> Void  in
                println("怎么就不调用了呢")
            if loginInfo != nil && error == nil {
                //获取群组列表
                EaseMob.sharedInstance().chatManager.asyncFetchMyGroupsList()
                //设置是否自动登录
//                EaseMob.sharedInstance().chatManager.isAutoLoginEnabled
                
                let dbError = EaseMob.sharedInstance().chatManager.loadDataFromDatabase()
                
                //发送自动登陆状态通知
                NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: NSNumber(bool: true))
            } else {
                switch (error.errorCode)
                {
                case .NotFound:
                    MBProgressHUD.showError(error.description, toView: self.view)
                case .NetworkNotConnected:
                    MBProgressHUD.showError("No network connection!", toView: self.view)

                case .ServerNotReachable:
                    MBProgressHUD.showError("Connect to the server failed!", toView: self.view)

                case .ServerAuthenticationFailure:
                    MBProgressHUD.showError(error.description, toView: self.view)
                case .ServerTimeout:
                    MBProgressHUD.showError("Connect to the server timed out!", toView: self.view)

                default:
                    MBProgressHUD.showError("Login failure", toView: self.view)
//                    TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                }

            }
           
            } ,onQueue: nil)
   
        
        
        
        
        println(self.viewControllers)

        let nav = self.viewControllers?.first as! UINavigationController
        
        
        // Do any additional setup after loading the view.
//        self.setViewControllers([Common.discoverVC, Common.messageListVC, Common.informationListVC], animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {

//        switch item.tag {
//        case 0:
//            Common.discoverVC.view.removeFromSuperview()
//            Common.messageListVC.view.removeFromSuperview()
//            Common.informationListVC.view.removeFromSuperview()
//        case 1:
//            Common.discoverVC.view.removeFromSuperview()
//            Common.messageListVC.view.removeFromSuperview()
//            Common.informationListVC.view.removeFromSuperview()
//
//            Common.rootViewController.mainTabBarController.view.addSubview(Common.discoverVC.view)
//            Common.rootViewController.mainTabBarController.view.bringSubviewToFront(Common.rootViewController.mainTabBarController.tabBar)
//
//        case 2:
//            Common.discoverVC.view.removeFromSuperview()
//            Common.messageListVC.view.removeFromSuperview()
//            Common.informationListVC.view.removeFromSuperview()
//
//            Common.rootViewController.mainTabBarController.view.addSubview(Common.messageListVC.view)
//            Common.rootViewController.mainTabBarController.view.bringSubviewToFront(Common.rootViewController.mainTabBarController.tabBar)
//
//        case 3:
//            Common.discoverVC.view.removeFromSuperview()
//            Common.messageListVC.view.removeFromSuperview()
//            Common.informationListVC.view.removeFromSuperview()
//
//            Common.rootViewController.mainTabBarController.view.addSubview(Common.informationListVC.view)
//            Common.rootViewController.mainTabBarController.view.bringSubviewToFront(Common.rootViewController.mainTabBarController.tabBar)
//
//        default:
//            break
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // 统计未读消息数
    func setupUnreadMessageCount()
    {
        let conversations = EaseMob.sharedInstance().chatManager.conversations
        var unreadCount = 0
        for  conversation : EMConversation in conversations as! Array {
            unreadCount += conversation.unreadMessagesCount().hashValue
        }
        
        if unreadCount > 0 {
            self.chatListVC.tabBarItem.badgeValue = "\(unreadCount)"
        }else {
            self.chatListVC.tabBarItem.badgeValue = nil
        }
        UIApplication.sharedApplication().applicationIconBadgeNumber = unreadCount;

    }
    
    func setupUntreatedApplyCount()
    {
        var unreadCount = ApplyViewController.shareController().dataSource.count
    //通讯录
//    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
//    if (unreadCount > 0) {
//    _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//    }else{
//    _contactsVC.tabBarItem.badgeValue = nil;
//    }
//    }
    }
    
    func networkChanged(connectionState: EMConnectionState)
    {
        self.connectionState = connectionState;
        self.chatListVC.networkChanged(connectionState);
    }
    
    //MARK: - call
    
    func canRecord() -> Bool
    {
        return false
//    __block BOOL bCanRecord = YES;
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
//    {
//    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
//    [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
//    bCanRecord = granted;
//    }];
//    }
//    }
//    
//    if (!bCanRecord) {
//    UIAlertView * alt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setting.microphoneNoAuthority", @"No microphone permissions") message:NSLocalizedString(@"setting.microphoneAuthority", @"Please open in \"Setting\"-\"Privacy\"-\"Microphone\".") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
//    [alt show];
//    }
//    
//    return bCanRecord;
    }
    
    func callOutWithChatter(notification: NSNotification)
    {
        let object: AnyObject = notification.object!
        if object.isKindOfClass(NSDictionary) {
            if !(self.canRecord()) {
            return
            }
        }
        var error: EMError?
        var chatter: String! = object["chatter"] as! String;
        var type = (object["type"] as! NSString).integerValue
        var callSession: EMCallSession?
        if type == EMCallSessionType.eCallSessionTypeAudio.rawValue {
            callSession = EaseMob.sharedInstance().callManager.asyncMakeVoiceCall(chatter, timeout: UInt(50), error: &error);
        }else if type == EMCallSessionType.eCallSessionTypeVideo.rawValue {
            if !(CallViewController.canVideo()) {
                return
            }
            callSession = EaseMob.sharedInstance().callManager.asyncMakeVideoCall(chatter, timeout: UInt(50), error: &error)
        }else {
        }
        if (callSession != nil && error == nil) {
            EaseMob.sharedInstance().callManager.removeDelegate(self)
            
            let callController = CallViewController(session: callSession, isIncoming: false)
            callController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            self.presentViewController(callController, animated: false, completion: nil)
        }
        
        if error != nil {
            //弹出错误提示 Alert
        }
    }
    
    func callControllerClose(notification: NSNotification)
    {
        EaseMob.sharedInstance().callManager.addDelegate(self, delegateQueue: nil)
    }
    
    //MARK: - IChatManagerDelegate 消息变化
    
    func didUpdateConversationList(conversationList: [AnyObject]?) {
        self.setupUnreadMessageCount()
        self.chatListVC.refreshDataSource()

    }

    // 未读消息数量变化回调
    func didUnreadMessagesCountChanged()
    {
        self.setupUnreadMessageCount()
    }

    func didFinishedReceiveOfflineMessages(offlineMessages: [AnyObject]?)
    {
        self.setupUnreadMessageCount()
    }
    
    func didFinishedReceiveOfflineCmdMessages(offlineCmdMessages: [AnyObject]?)
    {
    
    }
    
    func needShowNotification(fromChatter: NSString) -> Bool
    {
        var ret = true
        let igGroupIds = EaseMob.sharedInstance().chatManager.ignoredGroupIds
        for str: NSString in igGroupIds as! Array {
            if str == fromChatter{
                ret = false
                break
            }
        }
        return ret
    }
    
    // 收到消息回调
    func didReceiveMessage(message: EMMessage!) {
        let needShowNotification = (message.messageType != EMMessageType.eMessageTypeChat) ? self.needShowNotification(message.conversationChatter) : true
        if needShowNotification {
            if !DEVICE_IS_SIMULATOR {
                let isAppActivity = UIApplication.sharedApplication().applicationState == UIApplicationState.Active
                if !isAppActivity {
                    self.showNotificationWithMessage(message)
                }else {
                    self.playSoundAndVibration()
                }
            }
        }
    }

    
    func didReceiveCmdMessage(message: EMMessage)
    {
//    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
    }
    
    func playSoundAndVibration(){
        let timeInterval = NSDate().timeIntervalSinceDate(self.lastPlaySoundDate!)
        if timeInterval < kDefaultPlaySoundInterval {
            //如果距离上次响铃和震动时间太短, 则跳过响铃
            println("skip ringing & vibration \(NSDate()), \(self.lastPlaySoundDate)")
            return
        }
    //保存最后一次响铃时间
    self.lastPlaySoundDate = NSDate();

    // 收到消息时，播放音频
        EMCDDeviceManager.sharedInstance().playNewMessageSound()
    // 收到消息时，震动
        EMCDDeviceManager.sharedInstance().playVibration()
    }
    
    func showNotificationWithMessage(message: EMMessage)
    {
        let options = EaseMob.sharedInstance().chatManager.pushNotificationOptions
        //发送本地推送
        let notification = UILocalNotification()
        notification.fireDate = NSDate()//触发通知的时间

        if options.displayStyle == EMPushNotificationDisplayStyle.ePushNotificationDisplayStyle_messageSummary {
//            id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
            let messageBody: AnyObject? = message.messageBodies.first
            var messageStr: String? = nil
            
            switch (messageBody!.messageBodyType as MessageBodyType) {

            case MessageBodyType.eMessageBodyType_Text:
                
                messageStr = "Image"
                let body = messageBody as! EMTextMessageBody
//                messagestr = (messageBody as! EMTextMessageBody).text as? String
                
            case MessageBodyType.eMessageBodyType_Image:
                messageStr = "Image"
            case MessageBodyType.eMessageBodyType_Location:
                messageStr = "Location"
            case MessageBodyType.eMessageBodyType_Voice:
                messageStr = "Voice"
            case MessageBodyType.eMessageBodyType_Video:
                messageStr = "Vidio"
            default:
                messageStr = nil
            }
        
        var title = message.from
        if message.messageType == EMMessageType.eMessageTypeGroupChat {
            let groupArray = EaseMob.sharedInstance().chatManager.groupList
            for group: EMGroup in groupArray as! Array {
                if group.groupId == message.conversationChatter {
                    title = "\(message.groupSenderName)(\(group.groupSubject))"
                    break
                }
            }
        }
        else if (message.messageType == EMMessageType.eMessageTypeChatRoom) {
            let ud = NSUserDefaults.standardUserDefaults()
            let dic = EaseMob.sharedInstance().chatManager.loginInfo as Dictionary
            let str: String? = dic["username"] as? String
            let key = "OnceJoinedChatrooms_\(str)"
            let chatrooms = ud.objectForKey(key) as? NSMutableDictionary
            let chatroomName = chatrooms?.valueForKey(message.conversationChatter) as? NSString
            if chatroomName != nil {
                title = "\(message.groupSenderName)(\(chatroomName))"
            }
        }
        notification.alertBody = "\(title):\(messageStr)"
    } else {
            notification.alertBody = "you have a new message";
    }
    //warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];

        notification.alertAction = "Open"
        notification.timeZone = NSTimeZone.defaultTimeZone();
    notification.soundName = UILocalNotificationDefaultSoundName;

        var userInfo = NSMutableDictionary()
        
        userInfo.setObject(NSNumber(integer: message.messageType.rawValue), forKey: kMessageType);
        userInfo.setObject(message.conversationChatter, forKey: kConversationChatter)
        notification.userInfo = userInfo as [NSObject : AnyObject]
        
        //发送通知
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
    }
    
    //MARK - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）
    func didLoginWithInfo(loginInfo: [NSObject : AnyObject]!, error: EMError!) {
        if error != nil {
            
            //    NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
            //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
            //    message:hintText
            //    delegate:self
            //    cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
            //    otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
            //    nil];
            //    alertView.tag = 99;
            //    [alertView show];
            
            self.chatListVC.isConnect(false)
        }
    }

    //MARK: - IChatManagerDelegate 好友变化
    func didReceiveBuddyRequest(username: String!, message: String!) {
        if TARGET_IPHONE_SIMULATOR != 0 {
            self.playSoundAndVibration()
            
            let isAppActivity = UIApplication.sharedApplication().applicationState == UIApplicationState.Active
            if !isAppActivity {
                //发送本地推送
                var notification = UILocalNotification()
                notification.fireDate = NSDate()    //触发通知的时间
                notification.alertBody = "\(username) add you as a friend"
                notification.alertAction = "Open"
                notification.timeZone = NSTimeZone.defaultTimeZone()
            }
        }
        //刷新通讯录页面
//        [_contactsVC reloadApplyView];

    }
    func _removeBuddies(userNames: [AnyObject]?)
    {
        EaseMob.sharedInstance().chatManager.removeConversationsByChatters!(userNames, deleteMessages: true, append2Chat: true)
        self.chatListVC.refreshDataSource()
        
//        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//        ChatViewController *chatViewContrller = nil;
//        for (id viewController in viewControllers)
//        {
//            if ([viewController isKindOfClass:[ChatViewController class]] && [userNames containsObject:[(ChatViewController *)viewController chatter]])
//            {
//                chatViewContrller = viewController;
//                break;
//            }
//        }
//        if (chatViewContrller)
//        {
//            [viewControllers removeObject:chatViewContrller];
//            [self.navigationController setViewControllers:viewControllers animated:YES];
//        }
//        [self showHint:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"delete", @"delete"), userNames[0]]];
    }
    
    func didUpdateBuddyList(buddyList: [AnyObject]?, changedBuddies: [AnyObject]?, isAdd: Bool) {
        if !isAdd {
            var deletedBuddies  = NSMutableArray()
            for buddy: EMBuddy in changedBuddies as! Array{
                if !buddy.username.isEmpty {
                    deletedBuddies.addObject(buddy.username)
                }
            }
            if deletedBuddies.count > 0 {
                return
            }
            
            self._removeBuddies(deletedBuddies as [AnyObject])
        }
        //刷新通讯录界面
//        [_contactsVC reloadDataSource];
    }
    func didRemovedByBuddy(username: String!) {
        self._removeBuddies([username])
        //刷新通讯录界面
        //        [_contactsVC reloadDataSource];
    }
    func didAcceptedByBuddy(username: String!) {
        //刷新通讯录界面
        //[_contactsVC reloadDataSource]
    }
    func didRejectedByBuddy(username: String!) {
        //
    }
    func didAcceptBuddySucceed(username: String!) {
        //刷新通讯录界面
        //[_contactsVC reloadDataSource]
    }
    
    //MARK: - IChatManagerDelegate 群组变化
    func didReceiveGroupInvitationFrom(groupId: String!, inviter username: String!, message: String!) {
        if !DEVICE_IS_SIMULATOR {
            self.playSoundAndVibration()
        }
        //刷新通讯录界面
        //[_contactsVC reloadDataSource]
    }
    //接收到入群申请
    func didReceiveApplyToJoinGroup(groupId: String!, groupname: String!, applyUsername username: String!, reason: String!, error: EMError!) {
        if error == nil {
            if !DEVICE_IS_SIMULATOR {
                self.playSoundAndVibration()
            }
            //刷新通讯录界面
            //[_contactsVC reloadDataSource]
        }
    }
    func didReceiveGroupRejectFrom(groupId: String!, invitee username: String!, reason: String!) {
        
    }
    func didReceiveAcceptApplyToJoinGroup(groupId: String!, groupname: String!) {
        
    }
    
   
    //MARK: #pragma mark - IChatManagerDelegate 登录状态变化
    func didLoginFromOtherDevice() {
        EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(false, completion: {
            (info, error) in
                //alert tag = 100
            }, onQueue: nil)
    }
    func didRemovedFromServer() {
        EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(false, completion: {
        (info, error) in
            //alert tag = 101
        }, onQueue: nil)
    }
    func didServersChanged() {
        NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object:false)
    }
    func didAppkeyChanged() {
        NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object:false)

    }
    
    //MARK: - 自动登录回调
    func willAutoReconnect() {
        //
    }
    func didAutoReconnectFinishedWithError(error: NSError!) {
     //
    }
    
    //MARK: - ICallManagerDelegate
    func callSessionStatusChanged(callSession: EMCallSession!, changeReason reason: EMCallStatusChangedReason, error: EMError!) {
        if callSession.status == EMCallSessionStatus.eCallSessionStatusConnected {
            var error: EMError? = nil
            do {
                let isShowPicker = NSUserDefaults.standardUserDefaults().objectForKey("isShowPicker")!.boolValue
                if isShowPicker! {
                    error = EMError(code: EMErrorType.InitFailure, andDescription: "Establish call failure")
                    break
                }
                if !self.canRecord() {
                    error = EMError(code: EMErrorType.InitFailure, andDescription: "Establish call failure")
                    break
                }
                //WARNING: 在后台不能进行视频通话
                if callSession.type == EMCallSessionType.eCallSessionTypeVideo && ( UIApplication.sharedApplication().applicationState != UIApplicationState.Active || !CallViewController.canVideo() ) {
                    error = EMError(code: EMErrorType.InitFailure, andDescription: "Establish call failure")
                    break
                }
            
                if !isShowPicker {
                    EaseMob.sharedInstance().callManager.removeDelegate(self)
                    let callController = CallViewController(session: callSession, isIncoming: true)
                    callController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//                    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]])
//                    {
//                        ChatViewController *chatVc = (ChatViewController *)self.navigationController.topViewController;
//                        chatVc.isInvisible = YES;
//                    }
                }
            }while(false)
            if error != nil {
                EaseMob.sharedInstance().callManager.asyncEndCall(callSession.sessionId, reason: EMCallStatusChangedReason.eCallReasonHangup)
                return
            }
        }
    }
    
    
    //MARK: - public
    func jumpToChatList() {
        /*
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        [chatController hideImagePicker];
        }
        else if(_chatListVC)
        {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
        }

        */
    }
    func conversationTypeFromMessageType(type: EMMessageType) -> EMConversationType {
       var conversatinType = EMConversationType.eConversationTypeChat
        switch type {
        case .eMessageTypeChat:
            conversatinType = EMConversationType.eConversationTypeChat
        case .eMessageTypeGroupChat:
            conversatinType = EMConversationType.eConversationTypeGroupChat
        case .eMessageTypeChatRoom:
            conversatinType = EMConversationType.eConversationTypeChatRoom
        default:
            println()
        }
        return conversatinType
    }
    
    
    
    func didReceiveLocalNotification(notification: UILocalNotification)
    {
//    NSDictionary *userInfo = notification.userInfo;
//    if (userInfo)
//    {
//    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//    ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//    [chatController hideImagePicker];
//    }
//    
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//    if (obj != self)
//    {
//    if (![obj isKindOfClass:[ChatViewController class]])
//    {
//    [self.navigationController popViewControllerAnimated:NO];
//    }
//    else
//    {
//    NSString *conversationChatter = userInfo[kConversationChatter];
//    ChatViewController *chatViewController = (ChatViewController *)obj;
//    if (![chatViewController.chatter isEqualToString:conversationChatter])
//    {
//    [self.navigationController popViewControllerAnimated:NO];
//    EMMessageType messageType = [userInfo[kMessageType] intValue];
//    chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//    switch (messageType) {
//    case eMessageTypeGroupChat:
//    {
//    NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//    for (EMGroup *group in groupArray) {
//    if ([group.groupId isEqualToString:conversationChatter]) {
//    chatViewController.title = group.groupSubject;
//    break;
//    }
//    }
//    }
//    break;
//    default:
//    chatViewController.title = conversationChatter;
//    break;
//    }
//    [self.navigationController pushViewController:chatViewController animated:NO];
//    }
//    *stop= YES;
//    }
//    }
//    else
//    {
//    ChatViewController *chatViewController = (ChatViewController *)obj;
//    NSString *conversationChatter = userInfo[kConversationChatter];
//    EMMessageType messageType = [userInfo[kMessageType] intValue];
//    chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//    switch (messageType) {
//    case eMessageTypeGroupChat:
//    {
//    NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//    for (EMGroup *group in groupArray) {
//    if ([group.groupId isEqualToString:conversationChatter]) {
//    chatViewController.title = group.groupSubject;
//    break;
//    }
//    }
//    }
//    break;
//    default:
//    chatViewController.title = conversationChatter;
//    break;
//    }
//    [self.navigationController pushViewController:chatViewController animated:NO];
//    }
//    }];
//    }
//    else if (_chatListVC)
//    {
//    [self.navigationController popToViewController:self animated:NO];
//    [self setSelectedViewController:_chatListVC];
//    }
    }

}

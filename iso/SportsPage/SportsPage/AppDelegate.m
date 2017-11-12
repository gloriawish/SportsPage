//
//  AppDelegate.m
//  SportsPage
//
//  Created by absolute on 2016/10/17.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "AppDelegate.h"

//Root
#import "SPBootViewController.h"
//#import "SPLoginWayViewController.h"
#import "SPLoginViewController.h"
#import "SPTabBarViewController.h"

//通知跳转
//#import "SPChatViewController.h"

//微信SDK
#import "WXSDK/WXApi.h"
#import "WXApiManager.h"

//RongCloud
#import "RongCloud/RongIMKit.framework/Headers/RongIMKit.h"

//RongCloudDataSource
#import "SPIMDataSource.h"
#import "SPIMMessageContent.h"
#import "SPIMMessageContentShareClub.h"
#import "SPIMMessageContentInviteClub.h"
#import "SPIMMessageContentApplyClub.h"

//BusinessUnit
#import "SPIMBusinessUnit.h"
#import "SPUserInfoModel.h"
#import "SPUserBusinessUnit.h"

//Ping支付
#import "Pingpp.h"

//百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>

//QQ
#import <TencentOpenAPI/TencentOAuth.h>

//推送
#import "GeTuiSdk.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <GeTuiSdkDelegate/*,UNUserNotificationCenterDelegate*/> {
    BMKMapManager* _mapManager;
    NSString *_deviceToken;
}

@end

@implementation AppDelegate

#pragma mark - APPDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //设置Root
    self.window.rootViewController = [[SPTabBarViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    //初始化本地好友数组
    _friendsSortedListArray = [[NSMutableArray alloc] init];
    _friendsListArray = [[NSMutableArray alloc] init];

    //设置全局导航栏样式
    [self setUpNavAppearance];
    
    //Ping支付初始化
    [Pingpp setDebugMode:YES];
    
    //百度地图初始化
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:KEY_BAIDUMAP  generalDelegate:nil];
    if (!ret) {
        NSLog(@"地图初始化失败");
    }
    
    //微信SDK初始化
    [WXApi registerApp:KEY_WEIXIN];
    
    //QQ初始化
//    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:KEY_TENCENT andDelegate:self];
//    _tencentOAuth.redirectURI = KEY_REDIRECTURI;
//    _permissions = @[kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO];
    
    //融云初始化
    [self initRongCloud];
    
    //启动页停留1秒钟。
    [NSThread sleepForTimeInterval:1.5];
    
    //判断是否第一次使用 & 判断是否登陆
    BOOL isAweakBoot = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAweakBoot"];
    if (!isAweakBoot) {
        SPBootViewController *bootViewController = [[SPBootViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:bootViewController];
        navController.navigationBarHidden = true;
        [self.window.rootViewController presentViewController:navController animated:false completion:nil];
    } else {
        BOOL isAlreadyLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAlreadyLogin"];
        if (!isAlreadyLogin) {
            //SPLoginWayViewController *loginWayVC = [[SPLoginWayViewController alloc] init];
            SPLoginViewController *loginViewController = [[SPLoginViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            navController.navigationBarHidden = true;
            [self.window.rootViewController presentViewController:navController animated:false completion:nil];
        } else {
            NSString *userToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
            [self loginRongCloudServerWithToken:userToken];
        }
    }
    
    //清除推送消息
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //设置推送
    [self setUpNotification:application];
    
    //获取App冻结时本地推送信息
    [self getLocalNotification:launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]];
    //获取App冻结时远程推送信息
    [self getRemoteNotificationUserInfo:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];

    //初始化个推SDK,设置代理
    [GeTuiSdk startSdkWithAppId:KEY_GETUI_APPID appKey:KEY_GETUI_APPKEY appSecret:KEY_GETUI_APPSECRET delegate:self];
    //注册APNs
    [self registerRemoteNotification];
    
    //向服务器注册DeviceToken
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"\n>>>>>DeviceToken:%@",_deviceToken);
        [[RCIMClient sharedRCIMClient] setDeviceToken:_deviceToken];
        [GeTuiSdk registerDeviceToken:_deviceToken];
    });
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}
#pragma mark - 推送允许请求
//向用户请求允许推送
- (void)setUpNotification:(UIApplication *)application {
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert |
                                                  UIUserNotificationTypeBadge |
                                                  UIUserNotificationTypeSound)
                                      categories:nil];
    [application registerUserNotificationSettings:settings];
}

#pragma mark 注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"%s",__func__);
    [application registerForRemoteNotifications];
}

#pragma mark - 设置DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

//    NSString *deviceTokenStr = [[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
//    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!_deviceToken) {
        _deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
}

#pragma mark - 注册远程推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // 请检查App的APNs的权限设置，更多内容可以参考文档
    // http://www.rongcloud.cn/docs/ios_push.html。
    NSLog(@"注册远程推送失败:%@",error.localizedDescription);
}

#pragma mark - 本地通知
#pragma mark 本地通知内容获取(App未冻结)
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateInactive) {
        
//        NSLog(@"%@", notification.userInfo);
//        NSDictionary *dic = notification.userInfo[@"rc"];
//        RCConversationType conversationType;
//        if ([dic[@"cType"] isEqualToString:@"PR"]) {
//            conversationType = ConversationType_PRIVATE;
//        } else if ([dic[@"cType"] isEqualToString:@"GRP"]) {
//            conversationType = ConversationType_GROUP;
//        } else {
//            conversationType = ConversationType_PUSHSERVICE;
//        }
//
//        SPChatViewController *chatViewController = [[SPChatViewController alloc] initWithConversationType:conversationType
//                                                                                                 targetId:dic[@"fId"]];
//        chatViewController.hidesBottomBarWhenPushed = true;
//        RCConversationModel *model = [[RCConversationModel alloc] init];
//        model.conversationTitle = @"聊天";
//        chatViewController.model = model;
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tabBarController = (UITabBarController *)delegate.window.rootViewController;
        [(UINavigationController *)tabBarController.selectedViewController popToRootViewControllerAnimated:false];
        tabBarController.selectedIndex = 1;
    } else {
        NSLog(@"%ld",(long)application.applicationState);
    }
}

#pragma mark 本地通知内容获取(App被冻结)
- (void)getLocalNotification:(UILocalNotification *)localNotification {
    NSLog(@"localNotification:%@",localNotification);
}

#pragma mark - 远程推送
#pragma mark 远程推送内容获取(App未冻结)
/*
 {
 "aps" : 
 {
 "alert" : "You got your emails.",
 "badge" : 1,
 "sound" : "default"
 },
 "rc" : 
 {
 "cType" : "PR",
 "fId"   : "xxx",
 "oName" : "xxx",
 "tId"   : "xxxx"
 },
 "appData"   : "xxxx"
 }
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"userInfo:%@",userInfo);
}

#pragma mark 远程推送内容获取(App被冻结)
- (void)getRemoteNotificationUserInfo:(NSDictionary *)remoteNotificationUserInfo {
    NSLog(@"remoteNotificationUserInfo:%@",remoteNotificationUserInfo);
}

#pragma mark - GetUI
#pragma mark 注册APNs
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge
                                                 | UNAuthorizationOptionSound
                                                 | UNAuthorizationOptionAlert
                                                 | UNAuthorizationOptionCarPlay)
                              completionHandler:^(BOOL granted, NSError *_Nullable error) {
                                  if (!error) {
                                      NSLog(@"GetUI request authorization succeeded!");
                                  } else {
                                      NSLog(@"GetUI request authorization error:%@",error.localizedDescription);
                                  }
                              }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else
        // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert
                                        | UIUserNotificationTypeSound
                                        | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert
                                        | UIUserNotificationTypeSound
                                        | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

#pragma mark Background Fetch 接口回调处理
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark 统计APNs通知的点击数
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#pragma mark iOS10 App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

#pragma mark iOS10 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}

#endif

#pragma mark 获取注册成功的ClientID
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:@"CID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark ClientID注册失败
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

#pragma mark - Init
#pragma mark 设置全局导航栏
- (void)setUpNavAppearance {
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *textAttributes = @{NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar_black"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark 初始化融云
- (void)initRongCloud {
    [[RCIM sharedRCIM] initWithAppKey:KEY_RONGCLOUD];
    [[RCIMClient sharedRCIMClient] registerMessageType:[SPIMMessageContent class]];
    [[RCIMClient sharedRCIMClient] registerMessageType:[SPIMMessageContentShareClub class]];
    [[RCIMClient sharedRCIMClient] registerMessageType:[SPIMMessageContentInviteClub class]];
    [[RCIMClient sharedRCIMClient] registerMessageType:[SPIMMessageContentApplyClub class]];
    
    [RCIM sharedRCIM].userInfoDataSource = [SPIMDataSource shareInstance];
    [RCIM sharedRCIM].groupInfoDataSource = [SPIMDataSource shareInstance];
    [RCIM sharedRCIM].groupUserInfoDataSource = [SPIMDataSource shareInstance];
    //[RCIM sharedRCIM].currentUserInfo = nil;
    //[RCIM sharedRCIM].enableMessageAttachUserInfo = true;
    [RCIM sharedRCIM].connectionStatusDelegate = [SPIMDataSource shareInstance];
    [RCIM sharedRCIM].receiveMessageDelegate = [SPIMDataSource shareInstance];
    //[RCIM sharedRCIM].enablePersistentUserInfoCache = true;
    [RCIM sharedRCIM].enableSyncReadStatus = true;
    [RCIM sharedRCIM].enableTypingStatus = true;
    [RCIM sharedRCIM].enableMessageRecall = true;
    [RCIM sharedRCIM].maxRecallDuration = 60;
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE),@(ConversationType_GROUP)];
    
    [RCIM sharedRCIM].showUnkownMessage = true;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = true;
    
    //[RCIM sharedRCIM].groupMemberDataSource = [SPIMDataSource shareInstance];
    //[RCIM sharedRCIM].enableMessageMentioned = true;
}

#pragma mark 登录融云服务器
- (void)loginRongCloudServerWithToken:(NSString *)token {
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        
        NSLog(@"登陆成功,当前登录用户ID:%@", userId);
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isAlreadyLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //向后台发送CID
        NSString *CID = [[NSUserDefaults standardUserDefaults] stringForKey:@"CID"];
        if (CID) {
            [[SPUserBusinessUnit shareInstance] regPushServiceWithUserId:userId cid:CID platform:@"iOS" successful:^(NSString *successsfulString) {
                if ([successsfulString isEqualToString:@"successful"]) {
                    NSLog(@"regPushService successful:%@",successsfulString);
                } else {
                    NSLog(@"regPushService failure:%@",successsfulString);
                }
            } failure:^(NSString *errorString) {
                NSLog(@"regPushService AFN ERROR:%@",errorString);
            }];
        } else {
            NSLog(@"CID为空");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [[SPUserBusinessUnit shareInstance] regPushServiceWithUserId:userId cid:CID platform:@"iOS" successful:^(NSString *successsfulString) {
//                    if ([successsfulString isEqualToString:@"successful"]) {
//                        NSLog(@"regPushService successful:%@",successsfulString);
//                    } else {
//                        NSLog(@"regPushService failure:%@",successsfulString);
//                    }
//                } failure:^(NSString *errorString) {
//                    NSLog(@"regPushService AFN ERROR:%@",errorString);
//                }];
//            });
        }
        
        //通过userId搜索user用户的好友,全局缓存
        [[SPIMBusinessUnit shareInstance] getFriendsListWithUserId:userId successful:^(NSMutableArray *friendsSortedList, NSMutableArray *friendsList) {
            if (friendsList.count != 0 && friendsSortedList.count != 0) {
                _friendsSortedListArray = friendsSortedList;
                _friendsListArray = friendsList;
                NSLog(@"获取好友缓存成功");
            }
        } failure:^(NSString *errorString) {
            NSLog(@"网络请求好友数据失败:%@",errorString);
        }];
        
        //todo 群组缓存
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.window.rootViewController.view];
            [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"isAlreadyLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //SPLoginWayViewController *loginWayVC = [[SPLoginWayViewController alloc] init];
            SPLoginViewController *loginViewController = [[SPLoginViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            navController.navigationBarHidden = true;
            [self.window.rootViewController presentViewController:navController animated:true completion:^{
                ((UITabBarController *)self.window.rootViewController).selectedIndex = 0;
                [[RCIM sharedRCIM] logout];
            }];
        });
    } tokenIncorrect:^{
        NSLog(@"token错误");
        dispatch_async(dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.window.rootViewController.view];
            [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"isAlreadyLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //SPLoginWayViewController *loginWayVC = [[SPLoginWayViewController alloc] init];
            SPLoginViewController *loginViewController = [[SPLoginViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            navController.navigationBarHidden = true;
            [self.window.rootViewController presentViewController:navController animated:true completion:^{
                ((UITabBarController *)self.window.rootViewController).selectedIndex = 0;
                [[RCIM sharedRCIM] logout];
            }];
        });
    }];
}

#pragma mark - OpenURL
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    BOOL ret = false;
    if (url.query.length != 0) {
        if ([url.query containsString:@"code"] && [url.query containsString:@"state"]) {
            ret = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        } else if ([url.query containsString:@"returnKey"] && [url.query containsString:@"ret"]) {
            ret = [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
                if ([result isEqualToString:@"success"]) {
                    if ([_pingppResult isEqualToString:@"充值"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PINGPP_TopOn object:nil userInfo:nil];
                    } else if ([_pingppResult isEqualToString:@"付款"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PINGPP_PAY object:nil userInfo:nil];
                    }
                }
                _pingppResult = @"";
            }];
        }
    }
    
    if ([url.scheme isEqualToString:@"sportspage"]) {
        ret = true;
    }
    
    if ([url.scheme isEqualToString:@"tencent1105901492"]) {
        ret = [TencentOAuth HandleOpenURL:url];
    }
    
    return ret;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL ret = false;
    if (url.query.length != 0) {
        if ([url.query containsString:@"code"] && [url.query containsString:@"state"]) {
            ret = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        } else if ([url.query containsString:@"returnKey"] && [url.query containsString:@"ret"]) {
            ret = [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
                if ([result isEqualToString:@"success"]) {
                    if ([_pingppResult isEqualToString:@"充值"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PINGPP_TopOn object:nil userInfo:nil];
                    } else if ([_pingppResult isEqualToString:@"付款"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PINGPP_PAY object:nil userInfo:nil];
                    }
                }
                _pingppResult = @"";
            }];
        }
    }
    
    if ([url.scheme isEqualToString:@"sportspage"]) {
        ret = true;
    }
    
    if ([url.scheme isEqualToString:@"tencent1105901492"]) {
        ret = [TencentOAuth HandleOpenURL:url];
    }
    
    return ret;
}


@end

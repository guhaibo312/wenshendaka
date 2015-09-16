//
//  AppDelegate.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "LogInViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "NSString+URLEncoding.h"
#import "UIUtils.h"
#import "Configurations.h"
#import "UMSocial.h"
#import "MobClick.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import <BaiduMapAPI/BMapKit.h>
#import "LogInViewController.h"
#import "BaseNavigationViewController.h"
#import "GeTuiSdk.h"
#import "MKAnnotationView+WebCache.h"
#import "JWSocketManage.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>


@interface AppDelegate ()<NSURLConnectionDelegate,BMKGeneralDelegate,GeTuiSdkDelegate>
{
    UIScrollView *backScrollView;
    UIView *topView;                        //头部
    UIImageView *loadingimg ;
    NSTimer *timer;
}
@property (nonatomic, strong)     LogInViewController *logInVC;
@property (nonatomic, strong)     BMKMapManager* mapManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
//        //由于IOS8中定位的授权机制改变 需要进行手动授权
//        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//        //获取授权认证
//        [locationManager requestAlwaysAuthorization];
//        [locationManager requestWhenInUseAuthorization];
//    }
    
    self.mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:kBaiDuKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"地图初始化失败");
    }

//   NSThread *thread =  [[NSThread alloc]initWithTarget:self selector:@selector(resetMapInit) object:nil];
//    [thread start];
    
    //获取启动时收到的APN数据
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:message];
        [[JudgeMethods defaultJudgeMethods]getNotice:parm];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushNotication object:parm];
        AudioServicesPlaySystemSound(1307);
    }

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    [IQKeyboardManager sharedManager];

    [self registThirdKey];
    
    [self initWithSubView];

    return YES;
}

#pragma mark -- 地图初始化
- (void)resetMapInit
{
    // 要使用百度地图，请先启动BaiduMapManager
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    self.mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:kBaiDuKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"地图初始化失败");
    }
}

#pragma mark ------------------------  到登录界面
- (void)pushToLogInControllor:(BOOL)isPush
{
    dispatch_main_async_safe(^{
        if ([timer isValid]) {
            [timer invalidate];
        }
        if (loadingimg ) {
            [loadingimg removeFromSuperview];
        }
        
        UIImageView *img = (UIImageView *)[self.window  viewWithTag:100];
        if (img) {
            [img removeFromSuperview];
            img = nil;
        }
        
        if (!isPush){
            
            _mainVC  = NULL;
            _hobbyVC = NULL;
            
            if ([[User defaultUser].item.sector integerValue] == 30) {
                
                _mainVC = [MainViewController sharedInstance];
                self.window.rootViewController = _mainVC;
            }else{
                _hobbyVC = [HobbyMainViewController sharedInstance];
                self.window.rootViewController = _hobbyVC;
            }
            
            return;
        }
        
        self.logInVC = nil;
        self.logInVC = [[LogInViewController alloc]initWithQuery:nil];
        [self.window setRootViewController:[[BaseNavigationViewController alloc] initWithRootViewController:_logInVC]];

    });
   
}

- (void)registThirdKey
{
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kGetuiAppId appKey:kGetuiAppKey appSecret:kGetuiAppSecret];
    
    // [2]:注册APNS
    [self registerRemoteNotification];

    //融云客服
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];

    // 友盟统计（用于在线参数）
    [MobClick startWithAppkey: kUMAnalyKey];
    
    //开启崩溃统计
    [MobClick setCrashReportEnabled:YES];
    
    // 设置app 版本的统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //更新在线参数
    [MobClick updateOnlineConfig];
    
    
    // 友盟社会化分享
    [UMSocialData setAppKey: kUMAnalyKey];
    
//#ifdef DEBUG
//    //打开调试log的开关
//    [UMSocialData openLog:YES];
//#endif
    
    // 新浪微博
    [UMSocialSinaHandler openSSOWithRedirectURL: nil];
    
    
    // QQ
    [UMSocialQQHandler setQQWithAppId: kQQAppId
                               appKey: kQQAppKey
                                  url: @"http://meizhanggui.cc/m_index.htm"];
    
    [UMSocialQQHandler setSupportWebView:YES];
    
    
    // 微信
    [UMSocialWechatHandler setWXAppId: kWeChatAppId
                            appSecret: kWeChatAppSecret
                                  url: nil];
   
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    
    NSError *err = nil;
    __unsafe_unretained typeof(self) vc = self;
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:vc error:&err];
    [GeTuiSdk runBackgroundEnable:YES];
    
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:NO];
    
    if (err) {
        HBLog(@"个推－－－error %@",err);
    }
    
}

- (void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"Getui"];
        [action1 setIdentifier:@"NotificationActionOneIdent"];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:@"NotificationCategoryIdent"];
        [actionCategory setActions:@[action1]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}

+ (AppDelegate*) appDelegate {
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    return (AppDelegate*)delegate;
}

-(NSString*) vendor {
    
    static NSString* appVender = nil;
    if (appVender) {
        return appVender;
    }
    NSString* vendor1 = [NSString stringWithContentsOfFile: NIPathForBundleResource(nil, @"vendor.txt")
                                                  encoding: NSUTF8StringEncoding
                                                     error: nil];
    if ([vendor1 isNonEmpty]) {
        appVender = [vendor1 trimSpace];
        
    } else {
        appVender = @"normal";
    }
    
    return appVender;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[JWSocketManage shareManage]disConnect];
    [GeTuiSdk enterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //从后台回来的时候刷新登录状态
    [self startSdkWith:kGetuiAppId appKey:kGetuiAppKey appSecret:kGetuiAppSecret];
    
    if ([JudgeMethods defaultJudgeMethods].showKefuMessage) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kPushNotication object:nil];
    }
    [self performSelectorOnMainThread:@selector(requestRefushAction) withObject:nil waitUntilDone:YES];
    
}

- (void)requestRefushAction
{
    User *currentUser = [User defaultUser];
    if (currentUser.isLogIn == YES) {
        
        [[JWNetClient defaultJWNetClient]getNetClient:@"User/login" requestParm:nil result:^(id responObject, NSString *errmsg) {
            UIImageView *img = (UIImageView *)[[UIApplication sharedApplication].keyWindow  viewWithTag:100];
            if (img) {
                [img removeFromSuperview];
                img = nil;
            }
            if (errmsg) {
                [self pushToLogInControllor:YES];
                return;
            }else{
                User *currentUser = [User defaultUser];
                [currentUser logInSucessSaveInfo:responObject];
//                if (![JWSocketManage shareManage].isConnect) {
//                    [[JWSocketManage shareManage] startConnect];
//                }
            }
        }];
    }
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"%@",notification);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *tokenStr = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

    [GeTuiSdk registerDeviceToken:tokenStr];
    
    if (tokenStr) {
        [[NSUserDefaults standardUserDefaults]setValue:tokenStr forKey:kPushToken];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
   
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    [GeTuiSdk registerDeviceToken:@""];}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [[JudgeMethods defaultJudgeMethods]getNotice:parm];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPushNotication object:parm];
    AudioServicesPlaySystemSound(1307);
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

//- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//    [GeTuiSdk resume];
//    completionHandler(UIBackgroundFetchResultNewData);
//}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
   
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [[JudgeMethods defaultJudgeMethods]getNotice:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPushNotication object:parm];
    AudioServicesPlaySystemSound(1307);
}

#endif

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}


- (void)onGetNetworkState:(int)iError{
    NSLog(@"%d",iError);
}

- (void)onGetPermissionState:(int)iError
{
    NSLog(@"百度地图启动失败%d",iError);
}

- (void)initWithSubView
{
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImageView * _holdImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _holdImg.userInteractionEnabled = YES;
    NSString *imgName = @"Default@2x";
    if (SCREENHEIGHT > 480 && SCREENHEIGHT<=568) {
        imgName = @"Default-568h@2x";
    }else if (SCREENHEIGHT> 568 && SCREENHEIGHT<= 667){
        imgName = @"Default-667h@2x-1";
    }else if (SCREENHEIGHT <= 480){
        imgName = @"Default@2x";
    }else{
        imgName = @"Default-1104h@2x";
    }
    _holdImg.backgroundColor = [UIColor whiteColor];
    _holdImg.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:@"png"]];
    _holdImg.tag = 100;
    
    loadingimg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-20, SCREENHEIGHT/2+30, 40, 40)];
    loadingimg.image = [UIImage imageNamed:@"icon_loading.png"];
    timer =    [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(rotationLoadingImg:) userInfo:loadingimg repeats:YES];
    [_holdImg addSubview:loadingimg];
    [self.window addSubview:_holdImg];
    [self.window makeKeyAndVisible];

    NSString *logInfo = [[NSUserDefaults standardUserDefaults]objectForKey:CURRENTLOGININFO];
    BOOL logStatus = [[NSUserDefaults standardUserDefaults]boolForKey:CURRENTLOGINSTATUS];
    if (logStatus && logInfo  ) {
        [self performSelectorInBackground:@selector(autoLogInAction:) withObject:logInfo];
    }else{
        [self pushToLogInControllor:YES];
    }

}

- (void)rotationLoadingImg:(id)object
{
    if (loadingimg) {
        CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        shake.toValue = [NSNumber numberWithFloat:-M_PI * 2.0];
        shake.duration = 0.7;
        shake.autoreverses = NO;
        shake.cumulative = YES;
        shake.repeatCount = 0;
        shake.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [loadingimg.layer addAnimation:shake forKey:@"shakeAnimation"];
    }
    
}

- (void)autoLogInAction:(id)object
{
    NSString *string = (NSString *)object;
    NSDictionary *dict = [string JSONValue];
    NSString *account = [dict objectForKey:@"phonenum"];
    NSString *password = [dict objectForKey:@"password"];
    NSString *logType = dict[@"logInType"];
    if (!account || !password || !logType ) {
        [self pushToLogInControllor:YES];
        return;
    }
    NSString *URLstr = @"User/login";
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:account forKey:@"phonenum"];
    [parm setObject:password forKey:@"password"];
    
    [[JWNetClient defaultJWNetClient]POST:URLstr parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"]integerValue] == 0) {
            
            User *currentUser = [User defaultUser];
            [currentUser logInSucessSaveInfo:responseObject];
            
            TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
            [operationDB createdAllDataBase];
            [currentUser getNewDataFromServer];
            
            //启动socket
//            [[JWSocketManage shareManage]startConnect];

        }else{
            [self pushToLogInControllor:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self pushToLogInControllor:YES];
    }];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
}

#pragma mark - GexinSdkDelegate
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    
//    NSString *tokenStr =    [[NSUserDefaults standardUserDefaults] objectForKey :kPushToken];
//    if (tokenStr) {
//        [GeTuiSdk registerDeviceToken:tokenStr];
//    }
}

- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
//    NSData* payload = [GeTuiSdk retrivePayloadById:payloadId];
//    NSString *payloadMsg = nil;
//    if (payload) {
//        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
//                                              length:payload.length
//                                            encoding:NSUTF8StringEncoding];
//    }
    
}

- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {}
- (void)GeTuiSdkDidOccurError:(NSError *)error{}
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {}


#pragma mark--- 推送相关
- (void)setGeTuiToken:(NSString *)atoken
{
    [GeTuiSdk registerDeviceToken:atoken];
}

- (BOOL)setGeTuiTag:(NSArray *)aTag
{
    return [GeTuiSdk setTags:aTag];
}

- (void)bindGeTuiAlisa:(NSString *)alias
{
    [GeTuiSdk bindAlias:alias];
}

- (void)unbingdGeTuiAlisa:(NSString *)alias
{
    [GeTuiSdk unbindAlias:alias];
}

- (void)openGetui:(BOOL)open
{
    [GeTuiSdk setPushModeForOff:open];

}


@end

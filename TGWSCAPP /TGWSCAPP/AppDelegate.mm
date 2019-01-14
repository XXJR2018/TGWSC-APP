//
//  AppDelegate.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/7.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>

#import "RemoteNTFManager.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (void)umengTrack {
    [UMConfigure initWithAppkey:UMENG_APPKEY channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    
}

-(void)JPushSet:(NSDictionary *)JPushDic{
    // 注册极光
    [RemoteNTFManager defaultSettingWithOptions:JPushDic];
    
    //JPush 监听登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidLogin:)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidColse:)
                                                 name:kJPFNetworkDidCloseNotification
                                               object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    if (@available(iOS 11.0, *)) {
        //解决iOS11以后tableView顶部状态栏空白问题
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    // 友盟统计
    [self umengTrack];
    
    // 极光推送
    [self JPushSet:launchOptions];
    
    //初始化控制器
    [self setupMainUserInterface];
    
    return YES;
}
/**
 *  登录成功，设置别名，移除监听
 *
 *  @param notification <#notification description#>
 */
- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录极光推送");
    
    if (![[CommonInfo userInfo]objectForKey:@"encryptId"])
        return;
    
    NSString *strUid = [[CommonInfo userInfo] objectForKey:@"encryptId"];
    if(strUid.length > 8) {
        strUid = [strUid substringFromIndex:8];
        NSLog(@"   strUid:%@",  strUid);
        
        //极光推送2.9版本后， 设置别名，必须用此新方法
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JPUSHService setTags:nil alias:strUid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"setTags iResCode：%d-------------%@,-------------iAlias：%@",iResCode,iTags,iAlias);
                // 设置超时， 60S后重试
                if (iResCode == 6002) {
                    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:60.0];
                }
            }];
        });
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kJPFNetworkDidLoginNotification
                                                  object:nil];
}

- (void)networkDidColse:(NSNotification *)notification {
    //NSLog(@"极光推送连接失败");
}

- (void)delayMethod{
    
    NSLog(@"delayMethodEnd");
    if (![[CommonInfo userInfo]objectForKey:@"encryptId"])
        return;
    
    NSString *strUid = [[CommonInfo userInfo] objectForKey:@"encryptId"];
    if(strUid.length > 8){
        strUid = [strUid substringFromIndex:8];
        NSLog(@"   strUid:%@",  strUid);
        
        [JPUSHService setTags:nil alias:strUid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"setTags iResCode：%d-------------%@,-------------iAlias：%@",iResCode,iTags,iAlias);
            // 设置超时， 60S后重试
            
        }];
    }
}

#pragma mark - 申请通知权限
// 申请通知权限
- (void)replyPushNotificationAuthorization:(UIApplication *)application{
    //iOS 10 later
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //必须写代理，不然无法监听通知的接收与点击事件
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error && granted) {
            //用户点击允许
            NSLog(@"注册成功");
        }else{
            //用户点击不允许
            NSLog(@"注册失败");
        }
    }];
    // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
    //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"========%@",settings);
    }];
    
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
}

#pragma mark == 从其他APP跳转回自己APP回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    //  此处接收外部信息
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            //发送支付宝支付结果消息
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGPayResultNotification object:resultDic];
            
        }];

        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            //发送支付宝支付结果消息
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGPayResultNotification object:resultDic];
            
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    NSDictionary *dic = options;
    NSString *soureKey = [dic objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"];
    if ([soureKey isEqualToString:@"com.tencent.xin"]){
        return [WXApi handleOpenURL:url delegate:[DDGWeChat getSharedWeChat]];
    }else if ([soureKey isEqualToString:@"com.tencent.mqq"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QQShareResultNotification" object:url];
        return [TencentOAuth HandleOpenURL:url];
    }else if ([soureKey isEqualToString:@"com.apple.mobilesafari"]){
        return YES;
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark ==== PrivateMethods ====
#pragma mark -
- (void)setupMainUserInterface{
    //初始化界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [ResourceManager navgationTitleColor];
    [self.window makeKeyAndVisible];
    
    [self getStartUpViewController];
}

- (void)getStartUpViewController{
    
    //初始化界面
    self.tabBarRootViewController = [[TabBarViewController alloc] init];
    self.window.rootViewController = self.tabBarRootViewController;
    self.window.backgroundColor = [ResourceManager navgationTitleColor];
    
    [self.window makeKeyAndVisible];
    
}

#pragma mark ===
-(void)tencentDidNotNetWork{}

-(void)tencentDidNotLogin:(BOOL)cancelled{}

-(void)tencentDidLogin{}

-(void)isOnlineResponse:(NSDictionary *)response{}

#pragma mark ===
-(void)onResp:(QQBaseResp *)resp{}

-(void)onReq:(QQBaseReq *)req{}


@end

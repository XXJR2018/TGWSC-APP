//
//  TabBarViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/10.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "TabBarViewController.h"
#import "WCAlertview.h"
#import "PayResultVC.h"

@interface TabBarViewController ()<WCALertviewDelegate>
{
    TabViewController_1 *ctl1;
    TabViewController_2 *ctl2;
    TabViewController_3 *ctl3;
    TabViewController_4 *ctl4;
    
    UINavigationController *nav1;
    UINavigationController *nav2;
    UINavigationController *nav3;
    UINavigationController *nav4;
    
}

/*!
 @brief     进入后台时间
 */
@property (nonatomic, strong) NSDate *intoBackground;

/*!
 @brief     app升级链接
 */
@property (nonatomic, strong) NSString *APP_URL;


@end

@implementation TabBarViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark === TabBarButtons
-(TabBarSelectButtn *)tab1_Button{
    if (_tab1_Button == nil){
        _tab1_Button = [[TabBarSelectButtn alloc] initWithFrame:CGRectMake(0.f, 0, SCREEN_WIDTH/4, 49.f)];
        [_tab1_Button addTarget:self action:@selector(setButtonsState:) forControlEvents:UIControlEventTouchUpInside];
        _tab1_Button.tag = 100;
        
    }
    return _tab1_Button;
}

-(TabBarSelectButtn *)tab2_Button{
    if (_tab2_Button == nil){
        _tab2_Button = [[TabBarSelectButtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 49.f)];
        [_tab2_Button addTarget:self action:@selector(setButtonsState:) forControlEvents:UIControlEventTouchUpInside];
        _tab2_Button.tag = 101;
    }
    return _tab2_Button;
}

-(TabBarSelectButtn *)tab3_Button{
    if (_tab3_Button == nil){
        _tab3_Button = [[TabBarSelectButtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 * 2, 0, SCREEN_WIDTH/4, 49.f)];
        [_tab3_Button addTarget:self action:@selector(setButtonsState:) forControlEvents:UIControlEventTouchUpInside];
        _tab3_Button.tag = 102;
    }
    return _tab3_Button;
}

-(TabBarSelectButtn *)tab4_Button{
    if (_tab4_Button == nil){
        _tab4_Button = [[TabBarSelectButtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 * 3, 0, SCREEN_WIDTH/4, 49.f)];
        [_tab4_Button addTarget:self action:@selector(setButtonsState:) forControlEvents:UIControlEventTouchUpInside];
        _tab4_Button.tag = 103;
    }
    return _tab4_Button;
}


-(UINavigationController *)homeViewController{
    return _homeViewController = (UINavigationController *)self.selectedViewController;
}

#pragma mark === init
-(id)init{
    self = [super init];
    
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:DDGAccountEngineDidLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSucess:) name:DDGAccountEngineDidLogoutNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDidEnterBackgroudNotificaiton:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillEnterForegroundNotificaiton:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        // userInfo需要更新通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:DDGNotificationAccountNeedRefresh object:nil];
        
        // 推送消息处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotification:) name:DDGPushNotification object:nil];
        
        // 首页切换到别的页面的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchTab:) name:DDGSwitchTabNotification object:nil];
        
        // token过期通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenOutOfData:) name:DDGUserTokenOutOfDataNotification object:nil];
        
        // 支付宝支付结果通知  (跳到支付宝时， 有可能app会挂掉， 只能在tabbarView 页面接收支付消息)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ailiPayReslut:) name:DDGPayResultNotification object:nil];
        
       
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 版本检测
    [self onCheckVersion];
    
    //UI处理
    [self layoutViews];
    
//    [self PushNextViewControllerWith:@"OrderViewController"];
}

-(void)layoutViews{
    _buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - TabbarHeight, SCREEN_WIDTH, TabbarHeight)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.8)];
    line.backgroundColor = [ResourceManager color_3];
    [_buttonsView addSubview:line];
    _buttonsView.backgroundColor = [UIColor whiteColor];
    _buttonsView.tag = 1010;
    
    // 布置tabBar
    self.tab1_Button.normalImage = [ResourceManager tabBar_button1_gray];
    self.tab1_Button.selectedImage = [ResourceManager tabBar_button1_selected];
    self.tab2_Button.normalImage = [ResourceManager tabBar_button2_gray];
    self.tab2_Button.selectedImage = [ResourceManager tabBar_button2_selected];
    self.tab3_Button.normalImage = [ResourceManager tabBar_button3_gray];
    self.tab3_Button.selectedImage = [ResourceManager tabBar_button3_selected];
    self.tab4_Button.normalImage = [ResourceManager tabBar_button4_gray];
    self.tab4_Button.selectedImage = [ResourceManager tabBar_button4_selected];
    
    self.tab1_Button.selectedState = YES;
    self.tab2_Button.selectedState = NO;
    self.tab3_Button.selectedState = NO;
    self.tab4_Button.selectedState = NO;
    
    [_buttonsView addSubview:self.tab1_Button];
    [_buttonsView addSubview:self.tab2_Button];
    [_buttonsView addSubview:self.tab3_Button];
    [_buttonsView addSubview:self.tab4_Button];
    
    [self.tabBar removeFromSuperview];
    
    [self initViewControllers];
    
    [self ShowControllers];
    [self setButtonsState:self.tab1_Button];
}


-(void)initViewControllers{
    
    ctl1=[[TabViewController_1 alloc] init];
    nav1=[[UINavigationController alloc] initWithRootViewController:ctl1];
    
    ctl2 =[[TabViewController_2 alloc] init];
    nav2=[[UINavigationController alloc] initWithRootViewController:ctl2];
    
    ctl3 =[[TabViewController_3 alloc] init];
    nav3=[[UINavigationController alloc] initWithRootViewController:ctl3];
    
    ctl4 =[[TabViewController_4 alloc] init];
    nav4=[[UINavigationController alloc] initWithRootViewController:ctl4];
    
    ctl1.tabBar = ctl2.tabBar = ctl3.tabBar = ctl4.tabBar = self.buttonsView;
    
    [nav1 setNavigationBarHidden:NO];
    [nav1.navigationBar setHidden:YES];
    [nav2 setNavigationBarHidden:NO];
    [nav2.navigationBar setHidden:YES];
    [nav3 setNavigationBarHidden:NO];
    [nav3.navigationBar setHidden:YES];
    [nav4 setNavigationBarHidden:NO];
    [nav4.navigationBar setHidden:YES];
}

-(void)ShowControllers{
    self.viewControllers=@[nav1,nav2,nav3,nav4];
}

-(void)loginSucess:(NSNotification *)notification{
    if (nav1) {
        [nav1 popToRootViewControllerAnimated:NO];
    }
    if (nav2) {
        [nav2 popToRootViewControllerAnimated:NO];
    }
    if (nav3) {
        [nav3 popToRootViewControllerAnimated:NO];
    }
    if (nav4) {
        [nav4 popToRootViewControllerAnimated:NO];
    }
    [self setButtonsState:self.tab1_Button];
}

-(void)logoutSucess:(NSNotification *)notification{
    [self setButtonsState:self.tab1_Button];
    
    [DDGUserInfoEngine engine].parentViewController = self;
    [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
}


-(void)tokenOutOfData:(NSNotification *)notification{
    // 注销推送
    //[APService setAlias:@"" callbackSelector:nil object:nil];
    
    [[DDGAccountManager sharedManager] deleteUserData];
    
    [self loginSucess:nil];
    
    [DDGUserInfoEngine engine].parentViewController = self;
    [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
    if ([[DDGAccountManager sharedManager] isLoggedIn]) {
        [MBProgressHUD showErrorWithStatus:@"登录超时，请重新登录" toView:[DDGUserInfoEngine engine].loginViewController.view];
    }
}

/*
 * TabBar按钮显示状态
 */
-(void)setButtonsState:(TabBarSelectButtn *)button{
    
    [_tab1_Button setSelectedState:NO];
    [_tab2_Button setSelectedState:NO];
    [_tab3_Button setSelectedState:NO];
    [_tab4_Button setSelectedState:NO];
    
    if (button.tag == 100) {
        _tab1_Button.selectedState = YES;
        [ctl1 addButtonView];
    }else if (button.tag == 101) {
        _tab2_Button.selectedState = YES;
        [ctl2 addButtonView];
    }else if (button.tag == 102) {
        _tab3_Button.selectedState = YES;
        [ctl3 addButtonView];
    }else if (button.tag == 103) {
        _tab4_Button.selectedState = YES;
        [ctl4 addButtonView];
    }
    self.selectedIndex = button.tag - 100;
}


#pragma mark ---通知事件
#pragma mark notification
-(void)switchTab:(NSNotification *)notification{
    NSLog(@"user info is %@",notification.object);
    NSDictionary *dic = notification.object;
    int tab = [[dic objectForKey:@"tab"] intValue];
    if ( tab == 1) {
        [self setButtonsState:_tab1_Button];
    }else if (tab == 2) {
        [self setButtonsState:_tab2_Button];
    }else if (tab == 3) {
        [self setButtonsState:_tab3_Button];
    }else if (tab == 4) {
        [self setButtonsState:_tab4_Button];
    }
}

-(void)pushNotification:(NSNotification *)notification{
    NSLog(@"user info is %@",notification.userInfo);
    
}

- (void)handleDidEnterBackgroudNotificaiton:(NSNotification *)notification{
    //程序退到后台的时间
    self.intoBackground = [NSDate date];
}

- (void)handleWillEnterForegroundNotificaiton:(NSNotification *)notification{
    CFRunLoopRunInMode(kCFRunLoopDefaultMode,0.4, NO);
}

-(void) ailiPayReslut:(NSNotification *)notification
{
    NSLog(@"ailiPayReslut user info is %@",notification.object);
    NSDictionary *dic = notification.object;
    
    if (dic)
     {
        NSString *memo = dic[@"memo"];
        NSString *result = dic[@"result"];
        NSString *resultStatus = dic[@"resultStatus"];
        
        NSLog(@"memo: %@ result: %@  resultStatus: %@",memo,result,resultStatus);
        
        //    9000 订单支付成功
        //    8000 正在处理中
        //    4000 订单支付失败
        //    6001 用户中途取消
        //    6002 网络连接出错
        
        if ([resultStatus isEqualToString:@"9000"])
         {
            // 支付成功
            PayResultVC  *VC = [[PayResultVC alloc] init];
            VC.isSuceess = YES;
            
            [self setButtonsState:_tab1_Button];
            [nav1 pushViewController:VC animated:YES];
         }

     }
    
    
    
    //tradePassword = [dic objectForKey:@"password"] ;
    
}

#pragma mark  ---  传类名， 跳转页面
- (void)PushNextViewControllerWith:(NSString *)VCName {
    // 类名
    const char *className = [VCName cStringUsingEncoding:NSASCIIStringEncoding];
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass){
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
     }
    // 创建对象
    id instance = [[newClass alloc] init];
    [self.homeViewController pushViewController:instance animated:YES];
    
}


/*!
 @brief 网络变化的通知回调
 */
- (void)reachabilityChanged:(NSNotification *)notification{
    if ([ToolsUtlis isNetworkReachable]){
        
    }else{
        [MBProgressHUD showNoNetworkHUDToView:self.view];
    }
}

#pragma mark - 判断版本更新
-(void)onCheckVersion{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@wallet/upgradeInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:@{@"appID":@"tgwscIOS"} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      NSDictionary *dic = operation.jsonResult.attr;
                                                                                      //审核状态
                                                                                      [self parseDic:dic];
                                                                                      //升级弹窗
                                                                                      [self upVersionAlertView:dic];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      NSLog(@"error ==== %@",operation.jsonResult.message);
                                                                                  }];
    [operation start];
}

//升级弹窗
-(void)upVersionAlertView:(NSDictionary*) dic{
    self.APP_URL = [NSString stringWithFormat:@"%@",[dic objectForKey:@"upUrl"]];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *upVersion = [dic objectForKey:@"upVersion"];
    upVersion = [upVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *forceUpVersion = [dic objectForKey:@"forceUpgradeVersion"];
    forceUpVersion = [forceUpVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    //判断升级
    if (currentVersion.integerValue  < upVersion.integerValue && [[CommonInfo Verify] intValue] != 1) {
        if (currentVersion.integerValue <= forceUpVersion.integerValue) {
            //强制升级
            NSString *strMessageTemp = [dic objectForKey:@"upDesc"];
            strMessageTemp =  [strMessageTemp stringByReplacingOccurrencesOfString:@"/n" withString:@"\n"];
            
            WCAlertview * alert = [[WCAlertview alloc] initWithTitle:@"更新提示"
                                                             Message:strMessageTemp
                                                               Image:[UIImage imageNamed:@"upVersionImg"]
                                                            OkButton:@"立即升级"
                                                        CancelButton:@""];
            alert.strVerion = [NSString stringWithFormat:@"版本：v%@",[dic objectForKey:@"upVersion"]];
            alert.delegate = self;
            [alert show];
        }else{
            //非强制升级
            NSString *strMessageTemp = [dic objectForKey:@"upDesc"];
            strMessageTemp =  [strMessageTemp stringByReplacingOccurrencesOfString:@"/n" withString:@"\n"];
            WCAlertview * alert = [[WCAlertview alloc] initWithTitle:@"更新提示"
                                                             Message:strMessageTemp
                                                               Image:[UIImage imageNamed:@"upVersionImg"]
                                                            OkButton:@"立即升级"
                                                        CancelButton:@"下次再说"];
            alert.strVerion = [NSString stringWithFormat:@"版本：v%@",[dic objectForKey:@"upVersion"]];
            alert.delegate = self;
            [alert show];
        }
    }
    
}

-(void)didClickButtonAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.APP_URL] options:@{} completionHandler:nil];
        }break;
        case 1:{
            
        }break;
        default:
            break;
    }
}


// 判断是否审核中
-(void) parseDic:(NSDictionary*) dic{
    if (!dic){
        return;
    }
    // isTestByIos   1 表示审核中，   0  表示审核通过
    NSString *version = dic[@"upVersion"];
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger isTestByIosXxjr  = [dic[@"isTestByIos"] boolValue];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    // 网络版本号 和 isTestByIos ，都匹配，才是审核中
    if ([currentVersion intValue] > [version intValue] && isTestByIosXxjr == 1){
        [CommonInfo setVerify:@"1"];
    }else{
        [CommonInfo setVerify:@"0"];
    }
    
}

//获取并保存用户信息
-(void)getUserInfo {
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                  }];
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    // 保存用户信息
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[operation.jsonResult.attr objectForKey:@"custInfo"]];
    for (NSString *key in dic.allKeys) {   //避免NULL字段
        if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
            [dic setValue:@"" forKey:key];
        }
    }
    [CommonInfo setUserInfo:dic];
    
    //用户信息保存成功，更新显示用户信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationChangeUserInfo" object:nil];
}



@end

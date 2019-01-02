//
//  TabViewController_3.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_3.h"
#import "LZCartViewController.h"


@interface TabViewController_3 ()
{
    UIScrollView *_scView;
    
    LZCartViewController *VC;
   
}


@end

@implementation TabViewController_3

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"购物车"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"购物车"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.hideBackButton = YES;
    //[self layoutNaviBarViewWithTitle:@"购物车"];
  
    
    [self layoutUI];
    



}

-(void)layoutUI
{
    // 初始化时， 传入参数
    VC = [[LZCartViewController alloc] initWithVar:YES];
    
    // 设置了很多方法，只有这样设置才能正确设置子sub的view的大小
    CGRect frameTemp = self.view.frame;
    frameTemp.size.height = SCREEN_HEIGHT - TabbarHeight;
    VC.view.frame = frameTemp;
    
    [self addChildViewController:VC];
    [self.view addSubview:VC.view];
    
    
}

//-(void)layoutUI{
//
//    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - TabbarHeight)];
//    [self.view addSubview:_scView];
//    _scView.backgroundColor = [UIColor whiteColor];
//    _scView.bounces = NO;
//    _scView.pagingEnabled = NO;
//    _scView.showsVerticalScrollIndicator = NO;
//
//    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 170, 100)];
//    [_scView addSubview:loginBtn];
//    loginBtn.backgroundColor = [UIColor darkGrayColor];
//    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *loginOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 240, 170, 100)];
//    [_scView addSubview:loginOutBtn];
//    loginOutBtn.backgroundColor = [UIColor orangeColor];
//    [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
//}
//
//
//-(void)login{
//    if (![CommonInfo isLoggedIn]) {
//        [DDGUserInfoEngine engine].parentViewController = self;
//        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
//        return;
//    }
//}
//
//-(void)loginOut{
//    [CommonInfo AllDeleteInfo];
//    //发送退出登录通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:DDGAccountEngineDidLogoutNotification object:nil];
//
//}

-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

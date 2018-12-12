//
//  TabViewController_1.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_1.h"
#import "SearchVC.h"

@interface TabViewController_1 ()

@end

@implementation TabViewController_1

#pragma mark  ---   lifcycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"首页"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首页"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}


#pragma mark --- 布局UI
-(void)layoutUI{
    
    
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor purpleColor];
    [btn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
}

-(void) share
{
    
//    //开始登录
//    if (![[DDGAccountManager sharedManager] isLoggedIn])
//     {
//        [DDGUserInfoEngine engine].parentViewController = self;
//        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
//        return;
//     }
    
    SearchVC *VC = [[SearchVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}



-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

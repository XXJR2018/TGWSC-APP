//
//  TabViewController_1.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_1.h"

@interface TabViewController_1 ()

@end

@implementation TabViewController_1

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
    self.hideBackButton = YES;
    [self layoutNaviBarViewWithTitle:@"首页"];
    
    [self layoutUI];
}

-(void)layoutUI{
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor purpleColor];
    [btn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)share{
    UIImage *image = [UIImage imageNamed:@"Login-1"];
    [[DDGShareManager shareManager] share:ShareContentTypeNews items:@{@"title":@"title", @"subTitle":@"subTitle",@"image":UIImageJPEGRepresentation(image,1.0),@"url": @"www.baidu.com"} types:@[DDGShareTypeWeChat_haoyou,DDGShareTypeWeChat_pengyouquan,DDGShareTypeQQ,DDGShareTypeQQqzone,DDGShareTypeCopyUrl] showIn:self block:^(id result){
        NSDictionary *dic = (NSDictionary *)result;
        if ([[dic objectForKey:@"success"] boolValue]) {
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
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

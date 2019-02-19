//
//  AppraiseSuccessViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/15.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseSuccessViewController.h"

@interface AppraiseSuccessViewController ()

@end

@implementation AppraiseSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"评论"];
    
    [self layoutUI];
}

-(void)layoutUI{
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 156 * ScaleSize)];
    [self.view addSubview:bgImgView];
    bgImgView.image = [UIImage imageNamed:@"Tab_4-41"];
    bgImgView.userInteractionEnabled = YES;
    
    UIButton *appraiseSuccessBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 20, 150, 30)];
    [bgImgView addSubview:appraiseSuccessBtn];
    [appraiseSuccessBtn setTitle:@"评价成功" forState:UIControlStateNormal];
    [appraiseSuccessBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appraiseSuccessBtn setImage:[UIImage imageNamed:@"Tab_4-42"] forState:UIControlStateNormal];
    appraiseSuccessBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [appraiseSuccessBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(appraiseSuccessBtn.frame) + 5, SCREEN_WIDTH, 40)];
    [bgImgView addSubview:titleLabel];
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"已获得15积分\n坚持写有图评价，赚更多积分吧~";
    
    UIButton *backHomeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 110, CGRectGetMaxY(titleLabel.frame) + 10, 100, 35)];
    [bgImgView addSubview:backHomeBtn];
    backHomeBtn.layer.cornerRadius = 35/2;
    backHomeBtn.layer.borderWidth = 0.5;
    backHomeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    backHomeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backHomeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [backHomeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backHomeBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *checkAppraiseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, CGRectGetMaxY(titleLabel.frame) + 10, 100, 35)];
    [bgImgView addSubview:checkAppraiseBtn];
    checkAppraiseBtn.layer.cornerRadius = 35/2;
    checkAppraiseBtn.layer.borderWidth = 0.5;
    checkAppraiseBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    checkAppraiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [checkAppraiseBtn setTitle:@"查看评价" forState:UIControlStateNormal];
    [checkAppraiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkAppraiseBtn addTarget:self action:@selector(checkAppraise) forControlEvents:UIControlEventTouchUpInside];
    
   
}

//返回首页
-(void)backHome{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(1)}];
}

//查看评价
-(void)checkAppraise{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(1)}];
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

//
//  RechargeViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/11.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RechargeViewController.h"

@interface RechargeViewController ()

@end

@implementation RechargeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"充值"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"充值"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"充值"];
    
    [self layoutUI];
}

-(void)layoutUI{
    
    
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

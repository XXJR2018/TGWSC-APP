//
//  MyScoresViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "MyScoresViewController.h"

@interface MyScoresViewController ()

@end

@implementation MyScoresViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"签到"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"签到"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"积分中心"];
    
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

//
//  CustomerServiceViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CustomerServiceViewController.h"

@interface CustomerServiceViewController ()

@end

@implementation CustomerServiceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"客服中心"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"客服中心"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"客服中心"];
}

- (IBAction)tell:(id)sender {
    NSString *tellStr=[[NSString alloc] initWithFormat:@"telprompt://%@",@"186xxxx6979"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tellStr] options:@{} completionHandler:nil];
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

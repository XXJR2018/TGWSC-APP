//
//  RechargeDetailsViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/11.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RechargeDetailsViewController.h"

@interface RechargeDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lshNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeType;
@property (weak, nonatomic) IBOutlet UILabel *rechargeNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation RechargeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"充值详情"];
    
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

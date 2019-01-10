//
//  RefundCommitVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundCommitVC.h"

@interface RefundCommitVC ()

@end

@implementation RefundCommitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    if (1 == _iCommitType)
     {
         [self layoutNaviBarViewWithTitle:@"退款申请"];
     }
    else
     {
         [self layoutNaviBarViewWithTitle:@"退款退货"];
     }
    
    [self layoutUI];
}

#pragma mark  ---   布局UI
-(void) layoutUI
{
    
}

@end

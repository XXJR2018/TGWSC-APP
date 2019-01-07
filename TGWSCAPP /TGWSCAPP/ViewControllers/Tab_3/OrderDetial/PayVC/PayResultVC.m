//
//  PayResultVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/5.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "PayResultVC.h"

@interface PayResultVC ()
{
    UIView *viewFail;
    UIView *viewSuccess;
}
@end



@implementation PayResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"付款结果"];
    
    [self layoutUI];
    
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    
}

-(void) layoutSuccess
{
    
}

@end

//
//  InvoiceDetailsVC.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/21.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "InvoiceDetailsVC.h"

@interface InvoiceDetailsVC ()

@end

@implementation InvoiceDetailsVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发票详情"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发票详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"发票详情"];
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

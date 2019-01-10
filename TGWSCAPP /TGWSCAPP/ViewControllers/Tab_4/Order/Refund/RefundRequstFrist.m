//
//  RefundRequstFrist.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundRequstFrist.h"

@interface RefundRequstFrist ()

@end

@implementation RefundRequstFrist

#pragma mark  ---  lifecylce

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"售后服务"];
    
    NSLog(@"_dicParams:%@",_dicParams);
    [self layoutUI];
}


#pragma mark --- 布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    
    int iTopY = NavHeight + 10;
    int iLeftX = 0;
    int iCellHeight = 100;
    
    UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, iCellHeight)];
    [self.view addSubview:viewCell];
    viewCell.backgroundColor = [UIColor whiteColor];
    
    int iCellTopY = 10;
    int iCellLeftX = 15;
    
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY+5, 30, 30)];
    [viewCell addSubview:imgRight];
    imgRight.image = [UIImage imageNamed:@"re_tui"];
    imgRight.backgroundColor = [UIColor yellowColor];
    
    iCellLeftX += imgRight.width + 10;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, 200, 20)];
    [viewCell addSubview:label1];
    label1.textColor = [ResourceManager color_1];
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"退货退款";
    
    iCellTopY += label1.height+ 10;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX - 30, 12)];
    [viewCell addSubview:label2];
    label2.textColor = [ResourceManager midGrayColor];
    label2.font = [UIFont systemFontOfSize:11];
    label2.text = @"因为质量、错发等问题需要退货退款，或因漏发需要退款";
    
    
    
    
}

@end

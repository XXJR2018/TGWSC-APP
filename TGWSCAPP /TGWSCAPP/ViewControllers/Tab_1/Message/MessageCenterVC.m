//
//  MessageCenterVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/14.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "MessageCenterVC.h"

@interface MessageCenterVC ()

@end

@implementation MessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"消息中心"];

    [self layoutUI];
}


#pragma mark --- 布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    int iCellHeight = 65;
    int iTopY = NavHeight + 10;
    
    NSArray *arrName = @[@"通知消息",@"我的资产"];
    NSArray *arrSubTitle = @[@"查看与客服的沟通记录",@""];
    NSArray *arrImg = @[@"Refund_tui",@"Refund_qian"];
    
    
    for (int i = 0; i < [arrName count]; i++)
     {
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [self.view addSubview:viewCell];
        viewCell.tag = i;
        viewCell.backgroundColor = [UIColor whiteColor];
        
        int iCellTopY = 10;
        int iCellLeftX = 15;
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY+5, 30, 30)];
        [viewCell addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:arrImg[i]];
        
        iCellLeftX += imgLeft.width + 10;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, 200, 20)];
        [viewCell addSubview:label1];
        label1.textColor = [ResourceManager color_1];
        label1.font = [UIFont systemFontOfSize:16];
        label1.text = arrName[i];
        
        iCellTopY += label1.height+ 10;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX - 30, 12)];
        [viewCell addSubview:label2];
        label2.textColor = [ResourceManager midGrayColor];
        label2.font = [UIFont systemFontOfSize:11];
        label2.text = arrSubTitle[i];
        
        UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, (iCellHeight - 19*ScaleSize)/2, 11*ScaleSize, 19*ScaleSize)];
        [viewCell addSubview:imgRight];
        imgRight.image = [UIImage imageNamed:@"arrow_right"];
        

        
        
        //添加手势点击空白处隐藏键盘
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionView:)];
        gesture.numberOfTapsRequired  = 1;
        viewCell.userInteractionEnabled = YES;
        [viewCell addGestureRecognizer:gesture];
        
        iTopY += iCellHeight + 10;
     }
    
}

#pragma mark --- action
-(void) actionView:(UITapGestureRecognizer*) reg
{
    int iTag = (int)reg.view.tag;
    NSLog(@"actionView :%d ",iTag);
    
    if (0 == iTag)
     {
        //  退款退货

     }
    else if (1 == iTag)
     {
        // 退款

     }
}




@end

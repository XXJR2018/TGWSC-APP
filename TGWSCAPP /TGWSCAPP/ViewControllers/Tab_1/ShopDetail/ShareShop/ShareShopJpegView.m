//
//  ShareShopJpegView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/28.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "ShareShopJpegView.h"

@implementation ShareShopJpegView
{
    UIScrollView * scrolView;
    UILabel  *labelIndex;
    
    NSArray *arrImgURL;
    NSMutableArray *arrImg;
    int iCurNO;
}

-(ShareShopJpegView*) initWithArrImg:(NSArray *)arr   withNo:(int) iNo
{
    self =  [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    arrImgURL = arr;
    
    iCurNO = iNo;
    
    arrImg = [[NSMutableArray alloc] init];
    
    [self drawUI];
    
    return self;
}

-(void) drawUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.85];
    
    int iTopY = 70;
    int iLeftX = 15;
    UIButton *btnSaveAllImg = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 50)];
    [self addSubview:btnSaveAllImg];
    [btnSaveAllImg setTitle:@"  保存全部图片" forState:UIControlStateNormal];
    btnSaveAllImg.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSaveAllImg setImage:[UIImage imageNamed:@"com_download"] forState:UIControlStateNormal];
    [btnSaveAllImg addTarget:self action:@selector(actionSaveAll) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnColse = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - iLeftX - 50, iTopY, 50, 50)];
    [self addSubview:btnColse];
    [btnColse setImage:[UIImage imageNamed:@"com_colse3"] forState:UIControlStateNormal];
    [btnColse addTarget:self action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark --- action
-(void) actionClose
{
    [self removeAllSubviews];
    [self removeFromSuperview];
    self.hidden = YES;
}

-(void) actionSaveAll
{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

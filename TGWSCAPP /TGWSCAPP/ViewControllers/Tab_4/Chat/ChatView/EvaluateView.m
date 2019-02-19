//
//  EvaluateView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/19.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "EvaluateView.h"

@implementation EvaluateView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    int iPopWidth = 300;
    int iPopHeight = 500;
    UIView *viewPop = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iPopWidth)/2, (SCREEN_HEIGHT-iPopHeight)/2, iPopWidth, iPopHeight)];
    [self addSubview:viewPop];
    viewPop.backgroundColor = [UIColor whiteColor];
    viewPop.layer.masksToBounds = YES;
    viewPop.layer.cornerRadius = 10;
    
    
    int iLeftX = (iPopWidth - 30);
    int iTopY = 0;
    UIButton * btnBack = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 30, 30)];
    [viewPop addSubview:btnBack];
    //btnBack.backgroundColor = [UIColor yellowColor];
    [btnBack setImage:[UIImage imageNamed:@"com_colse"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark --- action
-(void) actionCancel
{
    self.hidden = YES;
}

@end

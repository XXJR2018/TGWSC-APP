//
//  ShowBigJpgView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/28.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "ShowBigJpgView.h"

@implementation ShowBigJpgView
{
    float fImgHeight;
    NSString *strImgUrl;
}

-(ShowBigJpgView*) initWithImgUrl:(NSString *)imgUrl   height:(float) fHeight
{
    self =  [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    fImgHeight = fHeight;
    
    strImgUrl = imgUrl;
    
    [self drawUI];
    
    return self;
}

-(void) drawUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:1.0];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionClose)];
    gesture.numberOfTapsRequired  = 1;
    [self addGestureRecognizer:gesture];
    
    int iTop = 0;
    if (fImgHeight < SCREEN_HEIGHT)
     {
        iTop = (SCREEN_HEIGHT - fImgHeight)/2;
     }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTop, SCREEN_WIDTH, fImgHeight)];
    [self addSubview:imgView];
    [imgView sd_setImageWithURL:[NSURL URLWithString:strImgUrl]];
    
    UIButton *btnBottom = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, SCREEN_HEIGHT - 50, 100, 50)];
    [self addSubview:btnBottom];
    [btnBottom setTitle:@"  保存图片" forState:UIControlStateNormal];
    btnBottom.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnBottom setImage:[UIImage imageNamed:@"com_gou1"] forState:UIControlStateNormal];
    
}


-(void) actionClose
{
    [self removeAllSubviews];
    [self removeFromSuperview];
    self.hidden = YES;

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}


@end

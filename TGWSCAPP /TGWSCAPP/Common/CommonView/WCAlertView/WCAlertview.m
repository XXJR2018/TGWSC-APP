//
//  WCAlertview.m
//  WCAlertView
//
//  Created by huangwenchen on 15/2/17.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import "WCAlertview.h"

#define UIColorFromRGB11(rgbValue) \
[UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.f \
green:((rgbValue >> 8) & 0xFF)/255.f \
blue:(rgbValue & 0xFF)/255.f \
alpha:1.0f]

static const CGFloat alertviewWidth = 225;
static const CGFloat titleHeight = 50.0;
static const CGFloat imageviewHeight = 150;
static const CGFloat buttonHeight = 35;
static const CGFloat buttonWidth = 90;

@interface WCAlertview()

@property (strong,nonatomic)UIDynamicAnimator * animator;
@property (strong,nonatomic)UIView * alertview;
@property (strong,nonatomic)UIView * backgroundview;
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * message;
@property (strong,nonatomic)NSString * cancelButtonTitle;
@property (strong,nonatomic)NSString * okButtonTitle;
@property (strong,nonatomic)UIImage * image;
@property (strong,nonatomic)UIButton * buttonVesion;


@end

@implementation WCAlertview

#pragma mark - Gesture
-(void)click:(UITapGestureRecognizer *)sender{
    // 屏蔽掉点击任何区域，消失
//    CGPoint tapLocation = [sender locationInView:self.backgroundview];
//    CGRect alertFrame = self.alertview.frame;
//    if (!CGRectContainsPoint(alertFrame, tapLocation)) {
//        [self dismiss];
//    }
}

#pragma mark -  private function
-(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:UIColorFromRGB(0x3f9dff) forState:UIControlStateNormal];
    button.layer.cornerRadius = 35/2;
    button.layer.borderWidth = 1;
    button.layer.borderColor = UIColorFromRGB(0x3f9dff).CGColor;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

// 创建灰色按钮
-(UIButton *)cancelButtonWithFrame:(CGRect)frame Title:(NSString *)title{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
    button.layer.cornerRadius = 35/2;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [ResourceManager color_6].CGColor;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

-(void)clickButton:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
        [self.delegate didClickButtonAtIndex:(button.tag -1)];
    }
    [self dismiss];
}
-(void)dismiss{
    [self.animator removeAllBehaviors];
    [UIView animateWithDuration:0.7 animations:^{
//        self.alpha = 0.0;
//        CGAffineTransform rotate = CGAffineTransformMakeRotation(0.9 * M_PI);
//        CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
//        self.alertview.transform = CGAffineTransformConcat(rotate, scale);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
         self.alertview = nil;
    }];
    
}
-(void)setUp{
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.backgroundview addGestureRecognizer:tap];
    
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertviewWidth, 250)];
    self.alertview.layer.cornerRadius = 10;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));
    self.alertview.backgroundColor = UIColorFromRGB11(0xfefcfb);//[UIColor whiteColor];
    self.alertview.clipsToBounds = YES;
    [self addSubview:self.alertview];

    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, alertviewWidth,imageviewHeight)];
    imageview.image = self.image;
    [self.alertview addSubview:imageview];
    
    CGRect cancelButtonFrame = CGRectMake(0, titleHeight + imageviewHeight,alertviewWidth,buttonHeight);
    if (self.okButtonTitle.length != 0 && self.okButtonTitle !=nil) {
        cancelButtonFrame = CGRectMake(alertviewWidth / 2 ,titleHeight + imageviewHeight, alertviewWidth/2,buttonHeight);
        CGRect okButtonFrame = CGRectMake(0,titleHeight + imageviewHeight, alertviewWidth/2,buttonHeight);
        UIButton * okButton = [self createButtonWithFrame:okButtonFrame Title:self.okButtonTitle];
        okButton.tag = 2;
        [self.alertview addSubview:okButton];
        
    }
    UIButton * cancelButton = [self createButtonWithFrame:cancelButtonFrame Title:self.cancelButtonTitle];
    cancelButton.tag = 1;
    [self.alertview addSubview:cancelButton];
}

-(void)setUp2{
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.backgroundview addGestureRecognizer:tap];
    
    int iTopY = 0;
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, alertviewWidth * ScaleSize, 250)];
    self.alertview.layer.cornerRadius = 12;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));
    self.alertview.backgroundColor = [UIColor whiteColor];
    self.alertview.clipsToBounds = YES;
    [self addSubview:self.alertview];
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake( 0, -0.5, alertviewWidth * ScaleSize,imageviewHeight * ScaleSize)];
    imageview.image = self.image;
    [self.alertview addSubview:imageview];
    
    self.buttonVesion = [[UIButton alloc] initWithFrame:CGRectMake((alertviewWidth * ScaleSize - 100)/2,CGRectGetMaxY(imageview.frame), 100, 20)];
    [self.buttonVesion setTitle:_strVerion forState:UIControlStateNormal];
    self.buttonVesion.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.buttonVesion setTitleColor:UIColorFromRGB(0x3f9dff) forState:UIControlStateNormal];
    [self.alertview addSubview:self.buttonVesion];

    UILabel * titleMesage = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.buttonVesion.frame), CGRectGetMaxY(self.buttonVesion.frame) + 10,titleHeight)];
    titleMesage.numberOfLines = 0;
    titleMesage.font = [UIFont systemFontOfSize:14];
    titleMesage.textColor = [ResourceManager color_1];
    titleMesage.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [titleMesage sizeThatFits:CGSizeMake(titleMesage.frame.size.width, MAXFLOAT)];
    CGRect frame = titleMesage.frame;
    frame.size.height = size.height;
    titleMesage.frame = frame;
    
    // 设置label的行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.message];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.message length])];
    [titleMesage setAttributedText:attributedString];

    [titleMesage sizeToFit]; // 高度自适应
    titleMesage.frame = CGRectMake(15, CGRectGetMaxY(self.buttonVesion.frame) + 10, alertviewWidth * ScaleSize - 30, titleMesage.frame.size.height);
    [self.alertview addSubview:titleMesage];
    
    
    if (self.cancelButtonTitle.length == 0) {
        CGRect okButtonFrame = CGRectMake((alertviewWidth * ScaleSize - 120 * ScaleSize)/2, CGRectGetMaxY(titleMesage.frame) + 20, 120 * ScaleSize, 35);
        UIButton * okButton = [self createButtonWithFrame:okButtonFrame Title:self.okButtonTitle];
        okButton.tag = 1;
        [self.alertview addSubview:okButton];
        
        iTopY +=CGRectGetMaxY(okButton.frame) + 15;
    }else{
        CGRect okButtonFrame = CGRectMake((alertviewWidth * ScaleSize - buttonWidth * ScaleSize * 2)/3, CGRectGetMaxY(titleMesage.frame) + 20, buttonWidth  * ScaleSize, 35);
        UIButton * okButton = [self createButtonWithFrame:okButtonFrame Title:self.okButtonTitle];
        okButton.tag = 1;
        [self.alertview addSubview:okButton];
        
        CGRect cancelButtonFrame = CGRectMake((alertviewWidth * ScaleSize - buttonWidth * ScaleSize * 2)/3 * 2 + buttonWidth * ScaleSize, CGRectGetMaxY(titleMesage.frame) + 20, buttonWidth  * ScaleSize, 35);
        UIButton * cancelButton = [self cancelButtonWithFrame:cancelButtonFrame Title:self.cancelButtonTitle];
        cancelButton.tag = 2;
        [self.alertview addSubview:cancelButton];
        
        iTopY +=CGRectGetMaxY(okButton.frame) + 15;
    }
   
    CGRect  frameTemp =  self.alertview.frame;
    frameTemp.size.height = iTopY;
    self.alertview.frame = frameTemp;
}


#pragma mark -  API
- (void)show {
    [self.buttonVesion setTitle:_strVerion forState:UIControlStateNormal];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    UISnapBehavior * sanp = [[UISnapBehavior alloc] initWithItem:self.alertview snapToPoint:self.center];
    sanp.damping = 0.5;
    [self.animator addBehavior:sanp];
    
}

-(instancetype)initWithTitle:(NSString *) title
                       Image:(UIImage *)image
                    OkButton:(NSString *)okButton
                CancelButton:(NSString *)cancelButton{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.image = image;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        
        [self setUp];
    }
    return self;
}


-(instancetype)initWithTitle:(NSString *) title
                     Message:(NSString*)message
                       Image:(UIImage *)image
                  OkButton:(NSString *)okButton
                CancelButton:(NSString *)cancelButton
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame])
     {
        self.title = title;
        self.image = image;
        self.message = message;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        
        [self setUp2];
    }
    return self;
}
@end

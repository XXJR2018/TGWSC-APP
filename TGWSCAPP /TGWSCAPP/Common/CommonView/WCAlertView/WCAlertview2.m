//
//  WCAlertview.m
//  WCAlertView
//
//  Created by huangwenchen on 15/2/17.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import "WCAlertview2.h"
#import "CCWebViewController.h"

#define UIColorFromRGB11(rgbValue) \
[UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.f \
green:((rgbValue >> 8) & 0xFF)/255.f \
blue:(rgbValue & 0xFF)/255.f \
alpha:1.0f]

static const CGFloat alertviewWidth = 300.0;
static const CGFloat titleHeight = 50.0;
static const CGFloat imageviewHeight = 100;
static const CGFloat buttonHeight = 35;
static const CGFloat buttonWidth = 95;
@interface WCAlertview2()

@property (strong,nonatomic)UIDynamicAnimator * animator;
@property (strong,nonatomic)UIView * alertview;
@property (strong,nonatomic)UIView * backgroundview;
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * message;
@property (strong,nonatomic)NSString * cancelButtonTitle;
@property (strong,nonatomic)NSString * okButtonTitle;
@property (strong,nonatomic)UIImage * image;
@property (strong,nonatomic)UIButton * buttonVesion;
@property (strong,nonatomic)UILabel * titleCKXQ;


@end

@implementation WCAlertview2

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
-(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 35/2;
    button.backgroundColor = [UIColor orangeColor];
    //button.layer.borderWidth = 0.5;
    //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

// 创建灰色按钮
-(UIButton *)createButtonWithFrame2:(CGRect)frame Title:(NSString *)title
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 35/2;
    button.backgroundColor = UIColorFromRGB11(0xd3cdca);
    //button.layer.borderWidth = 0.5;
    //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

-(void)clickButton:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex2:)]) {
        [self.delegate didClickButtonAtIndex2:(button.tag -1)];
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
    
    
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertviewWidth, 380)];
    //self.alertview.layer.cornerRadius = 5;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));
    self.alertview.backgroundColor = UIColorFromRGB11(0xfefcfb);//[UIColor whiteColor];
    self.alertview.clipsToBounds = YES;
    
    [self addSubview:self.alertview];
    
    

    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,alertviewWidth,titleHeight)];
    titleLabel.text = @"申请退款提醒";
    titleLabel.textColor = [ResourceManager color_1];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertview addSubview:titleLabel];
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, titleHeight, alertviewWidth, self.alertview.frame.size.height - titleHeight - 50 - 5); // frame中的size指UIScrollView的可视范围
    scrollView.contentSize = CGSizeMake(0, 500);
    //显示滚动条
    scrollView.showsVerticalScrollIndicator = YES;
    
    //  通过 UIImageView+ForScrollView ， 调用下面2句，实现滚动条一直显示
    scrollView.tag = 836913;
    [scrollView flashScrollIndicators];
    
    [self.alertview addSubview:scrollView];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, alertviewWidth - 20, 100)];
    label1.text = @"    平台所有客户都是自己申请的，必须通过手机验证才可以提交贷款申请，原则上一经抢单将不能退款，出现以下的情况，小小贷款在经过人工核实之后可以酌情退款。";
    label1.numberOfLines = 0;
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = UIColorFromRGB(0x4c4c4c);
    label1.textAlignment = NSTextAlignmentLeft;
    [label1 sizeToFit]; // 高度自适应
    [scrollView addSubview:label1];
    
    UIView *viewMid = [[UIView alloc] initWithFrame:CGRectMake(10, label1.frame.size.height+10, alertviewWidth-20, 180)];
    viewMid.backgroundColor = UIColorFromRGB(0xfefaf3);
    [scrollView addSubview:viewMid];
    
    UILabel *label2_1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertviewWidth - 20, 100)];
    label2_1.text = @"● 连续三天每天联系三次均出现客户电话为空号、停机、关机、拒接电话。";
    label2_1.numberOfLines = 0;
    label2_1.font = [UIFont systemFontOfSize:14];
    label2_1.textColor = UIColorFromRGB(0xf5793b);
    label2_1.textAlignment = NSTextAlignmentLeft;
    [label2_1 sizeToFit]; // 高度自适应
    [viewMid addSubview:label2_1];
    
    UILabel *label2_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label2_1.size.height + 20, alertviewWidth-20,100)];
    label2_2.numberOfLines = 0;
    label2_2.font = [UIFont systemFontOfSize:14];
    label2_2.textColor = UIColorFromRGB(0x808080);
    label2_2.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"● 客户完全不具备贷款条件[包括：客户是三无人员（无工作、无生意、无收入）、是信贷黑名单人员、年龄不符合贷款条件（小于20周岁或超过60周岁）、客户是同行]"];
    [str2 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf5793b) range:NSMakeRange(0,13)]; //设置一段的字体颜色
    label2_2.attributedText = str2;
    [label2_2 sizeToFit]; // 高度自适应
    [viewMid addSubview:label2_2];
    
    UILabel *label2_3 = [[UILabel alloc] initWithFrame:CGRectMake(0, label2_1.size.height + 20 +label2_2.size.height + 10, alertviewWidth-20,100)];
    label2_3.numberOfLines = 0;
    label2_3.font = [UIFont systemFontOfSize:14];
    label2_3.textColor = UIColorFromRGB(0x808080);
    label2_3.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:@"● 客户是异地（第一笔可以退，后续不可以退）"];
    [str3 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf5793b) range:NSMakeRange(0,7)]; //设置一段的字体颜色
    label2_3.attributedText = str3;
    [label2_3 sizeToFit]; // 高度自适应
    [viewMid addSubview:label2_3];
    
    
    float fTopY = CGRectGetMaxY(viewMid.frame)+10;
    UILabel *label3  = [[UILabel alloc] initWithFrame:CGRectMake(10, fTopY, alertviewWidth-20, 30)];
    label3.font = [UIFont systemFontOfSize:14];
    label3.textColor = UIColorFromRGB(0x4c4c4c);
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"特别提醒";
    [scrollView addSubview:label3];
    
    
    
    UILabel *label3_1  = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label3.frame)+10, alertviewWidth-20, 30)];
    label3_1.font = [UIFont systemFontOfSize:14];
    label3_1.textColor = UIColorFromRGB(0x808080);
    label3_1.textAlignment = NSTextAlignmentLeft;
    label3_1.text = @"● 价格低于10元的单子将不能申请退款；\n\n● 申请退单必须在抢完单后10个工作日内提交，超过时限不予处理;\n\n● 小小贷款将在用户申请退款之后5个工作日内进行处理。";
    label3_1.numberOfLines = 0;
    [label3_1 sizeToFit]; // 高度自适应
    [scrollView addSubview:label3_1];

    
    CGRect cancelButtonFrame = CGRectMake(15, self.alertview.frame.size.height - 50,alertviewWidth-30,buttonHeight);
    UIButton * cancelButton = [self createButtonWithFrame:cancelButtonFrame Title:@"我知道了"];
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
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertviewWidth, 250)];
    //self.alertview.layer.cornerRadius = 8;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));
    //self.alertview.backgroundColor = UIColorFromRGB11(0xfefcfb);//  UIColorFromRGB11(0xfefcfb);
    self.alertview.clipsToBounds = YES;
    [self addSubview:self.alertview];
    
    

    
    
    
    // 加入顶部的VIEW
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0,0, alertviewWidth,imageviewHeight)];
    headView.backgroundColor = [UIColor clearColor];
    [self.alertview addSubview:headView];
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, alertviewWidth,imageviewHeight)];
    imageview.image = self.image;
    [self.alertview addSubview:imageview];
    
    

    // 加入底部的VIEW
    UIView * bottonView = [[UIView alloc] initWithFrame:CGRectMake(0,imageviewHeight, alertviewWidth,self.alertview.frame.size.height - imageviewHeight)];
    bottonView.backgroundColor = UIColorFromRGB11(0xfefcfb);
    [self.alertview addSubview:bottonView];
    
    
    iTopY += imageviewHeight + 10;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,iTopY,alertviewWidth,20)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertview addSubview:titleLabel];

    
    iTopY += titleLabel.frame.size.height + 10;
    UILabel * titleMesage = [[UILabel alloc] initWithFrame:CGRectMake(40,iTopY,alertviewWidth-80,titleHeight)];
    titleMesage.text = self.message;
    titleMesage.numberOfLines = 0;
    titleMesage.font = [UIFont systemFontOfSize:14];
    titleMesage.textColor = UIColorFromRGB(0x333333);
    titleMesage.textAlignment = NSTextAlignmentLeft;
    [titleMesage sizeToFit]; // 高度自适应
    [self.alertview addSubview:titleMesage];
    
    iTopY += titleMesage.frame.size.height + 10;
    _titleCKXQ = [[UILabel alloc] initWithFrame:CGRectMake(40,iTopY,alertviewWidth-80,10)];
    
    // 添加下划线
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:@""];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    
    _titleCKXQ.attributedText = content;
    _titleCKXQ.textAlignment = NSTextAlignmentCenter;
    _titleCKXQ.font = [UIFont systemFontOfSize:14];
    _titleCKXQ.textColor = [UIColor orangeColor];
    [self.alertview addSubview:_titleCKXQ];

    
    _titleCKXQ.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [_titleCKXQ addGestureRecognizer:labelTapGestureRecognizer];
    
    
    
    iTopY += _titleCKXQ.frame.size.height + 15;
    CGRect cancelButtonFrame = CGRectMake((alertviewWidth- buttonWidth)/2, iTopY,buttonWidth,buttonHeight);
    if (self.okButtonTitle.length != 0 && self.okButtonTitle !=nil) {
        int iJianJu = (alertviewWidth- 2*buttonWidth)/3;
        CGRect okButtonFrame = CGRectMake(iJianJu,iTopY, buttonWidth,buttonHeight);
        UIButton * okButton = [self createButtonWithFrame2:okButtonFrame Title:self.okButtonTitle];
        okButton.tag = 2;
        [self.alertview addSubview:okButton];
        
        int iLeftX = iJianJu + buttonWidth + iJianJu;
        cancelButtonFrame = CGRectMake(iLeftX ,iTopY, buttonWidth,buttonHeight);
        
    }
    UIButton * cancelButton = [self createButtonWithFrame:cancelButtonFrame Title:self.cancelButtonTitle];
    cancelButton.tag = 1;
    [self.alertview addSubview:cancelButton];
    iTopY +=buttonHeight + 15;
    
    // alertview， 再自适应高度
    CGRect  frameTemp =  self.alertview.frame;
    frameTemp.size.height = iTopY;
    self.alertview.frame = frameTemp;
    
    // 底部VIEW， 再自适应高度
    frameTemp =  bottonView.frame;
    frameTemp.size.height = iTopY - imageviewHeight;
    bottonView.frame = frameTemp;
    

    
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    
    NSLog(@"%@被点击了",label.text);

    [self dismiss];
    CCWebViewController *ctl = [CCWebViewController new];
    ctl.isPresent = YES;
    ctl.homeUrl = [NSURL URLWithString:_strUrl];
    ctl.titleStr = @"详情";
    [self.parentVC presentViewController:ctl animated:YES completion:nil];
    
}


-(void) setStrNoteMessage:(NSString *)strNoteMessage
{
    NSLog(@"strNoteMessage:%@" ,strNoteMessage);
    if (strNoteMessage &&
        strNoteMessage.length > 0)
     {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:strNoteMessage];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        
        _titleCKXQ.attributedText = content;
     }
    else
     {
        _titleCKXQ.hidden = YES;
     }
}

#pragma mark -  API
- (void)show {
    
    //[self.buttonVesion setTitle:_strVerion forState:UIControlStateNormal];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    UISnapBehavior * sanp = [[UISnapBehavior alloc] initWithItem:self.alertview snapToPoint:self.center];
    sanp.damping = 0.5;
    [self.animator addBehavior:sanp];
    
}

-(instancetype)initWithTitle:(NSString *) title
                       Image:(UIImage *)image
                CancelButton:(NSString *)cancelButton
                    OkButton:(NSString *)okButton{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        //self.image = image;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        
        [self setUp];
    }
    return self;
}


-(instancetype)initWithTitle:(NSString *) title
                     Message:(NSString*)message
                       Image:(UIImage *)image
                CancelButton:(NSString *)cancelButton
                    OkButton:(NSString *)okButton
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

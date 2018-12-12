//
//  LoginVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/12/11.
//  Copyright © 2018 Cary. All rights reserved.
//

#import "LoginVC.h"
#import "CCWebViewController.h"

@interface LoginVC ()
{
    UITextField  *fieldPhone;   // 手机号码
    UITextField  *fieldCode;    // 验证码
    UIButton *btnCode; // 验证码按钮
    
    UIButton *btnOK;  // 进入商城按钮
    
    UIButton *btnCheck; // 勾选协议按钮
    BOOL  isCheck;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutUI];
}

#pragma mark ---  布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    int iLeftX = 25;
    int iTopY = 90;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 30)];
    [self.view addSubview:labelTitle];
    labelTitle.font = [UIFont systemFontOfSize:20];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.text = @"欢迎登录天狗窝商城";
    
    
    iTopY += labelTitle.height + 30;
    fieldPhone = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 30)];
    [self.view addSubview:fieldPhone];
    fieldPhone.font = [UIFont systemFontOfSize:14];
    fieldPhone.textColor = [ResourceManager color_1];
    fieldPhone.placeholder = @"请输入手机号";
    
    iTopY += fieldPhone.height + 5;
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 1)];
    [self.view addSubview:viewFG1];
    viewFG1.backgroundColor = [ResourceManager color_5];
    
    iTopY += 20;
    fieldCode = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX - 105, 30)];
    [self.view addSubview:fieldCode];
    //fieldCode.backgroundColor = [UIColor yellowColor];
    fieldCode.font = [UIFont systemFontOfSize:14];
    fieldCode.textColor = [ResourceManager color_1];
    fieldCode.placeholder = @"请输入验证码";
    
    
    UIView *viewFG_Mid = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - iLeftX - 100, iTopY, 1, 30)];
    [self.view addSubview:viewFG_Mid];
    viewFG_Mid.backgroundColor = [ResourceManager color_5];
    
    btnCode = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - iLeftX - 90, iTopY, 90, 30)];
    [self.view addSubview:btnCode];
    //btnCode.backgroundColor = [UIColor yellowColor];
    [btnCode addTarget:self action:@selector(actionCode) forControlEvents:UIControlEventTouchUpInside];
    [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btnCode setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnCode.titleLabel.font = [UIFont systemFontOfSize:14];
    
    iTopY += fieldCode.height + 5;
    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 1)];
    [self.view addSubview:viewFG2];
    viewFG2.backgroundColor = [ResourceManager color_5];
    
    iTopY += 50;
    btnOK = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH- 2*iLeftX, 40)];
    [self.view addSubview:btnOK];
    btnOK.backgroundColor = UIColorFromRGB(0xc4bab1);
    btnOK.cornerRadius = btnOK.height/2;
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK setTitle:@"进入商城" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(actionDL) forControlEvents:UIControlEventTouchUpInside];
    btnOK.userInteractionEnabled = NO;
    isCheck = NO;
    
    iTopY += btnOK.height + 20;
    btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX+20, iTopY, 20, 20)];
    [self.view addSubview:btnCheck];
    //btnCheck.backgroundColor = [UIColor yellowColor];
    [btnCheck setImage:[UIImage imageNamed:@"com_gou1"] forState:UIControlStateNormal];
    [btnCheck addTarget:self action:@selector(actionCheck) forControlEvents:UIControlEventTouchUpInside];
    
    iLeftX += 20 + btnCheck.width +10;
    UILabel *labelXY = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX , iTopY, SCREEN_WIDTH - iLeftX -15, 20)];
    [self.view addSubview:labelXY];
    labelXY.font = [UIFont systemFontOfSize:12];
    labelXY.textColor = [ResourceManager color_1];
    labelXY.text = @"我已阅读并同意 \"用户协议\"和\"隐私协议\"";
    
    
    UIButton *btnUser = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX + 90, iTopY, 60, 20)];
    [self.view addSubview:btnUser];
    //btnUser.backgroundColor = [UIColor yellowColor];
    [btnUser addTarget:self action:@selector(actionUser) forControlEvents:UIControlEventTouchUpInside];
    
    iLeftX += 90 + btnUser.width +10;
    UIButton *btnSecret = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 60, 20)];
    [self.view addSubview:btnSecret];
    //btnSecret.backgroundColor = [UIColor blueColor];
    [btnSecret addTarget:self action:@selector(actionSecret) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY = SCREEN_HEIGHT -  150;
    UILabel *labelWX = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [self.view addSubview:labelWX];
    labelWX.font = [UIFont systemFontOfSize:11];
    labelWX.textColor = [ResourceManager lightGrayColor];
    labelWX.textAlignment = NSTextAlignmentCenter;
    labelWX.text = @"您还可以用以下方式登录";
    
    int iFGWidth = 90;
    int iFGLeftX = 20;
    if (IS_IPHONE_5_OR_LESS)
     {
        iFGWidth = 70;
     }
    UIView *viewFGLeft = [[UIView alloc] initWithFrame:CGRectMake(iFGLeftX, iTopY+10, iFGWidth, 1)];
    [self.view addSubview:viewFGLeft];
    viewFGLeft.backgroundColor = [ResourceManager color_5];
    
    UIView *viewFGRight = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - iFGWidth - iFGLeftX, iTopY+10, iFGWidth, 1)];
    [self.view addSubview:viewFGRight];
    viewFGRight.backgroundColor = [ResourceManager color_5];
    
    iTopY += labelWX.height + 20;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 46)/2, iTopY, 46, 40)];
    [self.view addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"Login_WX"];
    
    iTopY +=imgView.height + 15;
    UILabel *labelWXDL = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [self.view addSubview:labelWXDL];
    labelWXDL.font = [UIFont systemFontOfSize:11];
    labelWXDL.textColor = [ResourceManager lightGrayColor];
    labelWXDL.textAlignment = NSTextAlignmentCenter;
    labelWXDL.text = @"微信登录";
    
    
    UIButton *btnWXDL = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -  150, SCREEN_WIDTH, 150)];
    [self.view addSubview:btnWXDL];
    [btnWXDL addTarget:self action:@selector(actionWXDL) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}


#pragma mark ---   action
-(void) actionCode
{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                btnCode.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btnCode setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                btnCode.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void) actionUser
{

    NSString *url = [NSString stringWithFormat:@"%@tgwproject/AgreePrivacy",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"用户协议"];
}

-(void) actionSecret
{
    NSString *url = [NSString stringWithFormat:@"%@tgwproject/AgreePrivacy",[PDAPI WXSysRouteAPI]];
    //NSString *url = [NSString stringWithFormat:@"https://www.baidu.com",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"隐私协议"];
    
}


-(void) actionCheck
{
    isCheck = !isCheck;
    if (isCheck )
     {
        [btnCheck setImage:[UIImage imageNamed:@"com_gou2"] forState:UIControlStateNormal];
        btnOK.backgroundColor = [ResourceManager mainColor];
        btnOK.userInteractionEnabled = YES;
     }
    else
     {
        [btnCheck setImage:[UIImage imageNamed:@"com_gou1"] forState:UIControlStateNormal];
        btnOK.backgroundColor = UIColorFromRGB(0xc4bab1);
        btnOK.userInteractionEnabled = NO;
     }
}

-(void) actionWXDL
{
    
}

-(void) actionDL
{
    if (fieldPhone.text &&
        ![fieldPhone.text isMobileNumber])
     {
        [MBProgressHUD showErrorWithStatus:@"请输入正确的手机号码" toView:self.view];
        return;
     }
    
}

@end

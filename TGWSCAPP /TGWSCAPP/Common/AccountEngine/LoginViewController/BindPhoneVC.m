//
//  BindPhoneVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/12.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "BindPhoneVC.h"

@interface BindPhoneVC ()
{
    UILabel *labelTitle; // 标题text
    
    UITextField  *fieldPhone;   // 手机号码
    UITextField  *fieldCode;    // 验证码
    UIButton *btnCode; // 验证码按钮
    
    UIButton *btnOK;  // 进入商城按钮
    
    UIButton *btnCheck; // 勾选协议按钮
    UILabel *labelXY;  //  协议text
    BOOL  isCheck;
    
    NSString *smsTokenId;
}
@end

@implementation BindPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self layoutUI];
}

#pragma mark ---  布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
    int iLeftX = 25;
    int iTopY = 90;
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 30)];
    [self.view addSubview:labelTitle];
    labelTitle.font = [UIFont systemFontOfSize:20];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.text = @"HI,请关联您的手机号码";
    
    
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
    btnOK.backgroundColor =  [ResourceManager mainColor];//UIColorFromRGB(0xc4bab1);
    btnOK.cornerRadius = btnOK.height/2;
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK setTitle:@"进入商城" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(actionDL) forControlEvents:UIControlEventTouchUpInside];
    //btnOK.userInteractionEnabled = NO;
    //isCheck = NO;
    
//    iTopY += btnOK.height + 20;
//    btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX+20, iTopY, 20, 20)];
//    [self.view addSubview:btnCheck];
//    //btnCheck.backgroundColor = [UIColor yellowColor];
//    [btnCheck setImage:[UIImage imageNamed:@"com_gou1"] forState:UIControlStateNormal];
//    [btnCheck addTarget:self action:@selector(actionCheck) forControlEvents:UIControlEventTouchUpInside];
//
//    iLeftX += 20 + btnCheck.width +10;
//    labelXY = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX , iTopY, SCREEN_WIDTH - iLeftX -15, 20)];
//    [self.view addSubview:labelXY];
//    labelXY.font = [UIFont systemFontOfSize:12];
//    labelXY.textColor = [ResourceManager color_1];
//    labelXY.text = @"我已阅读并同意 \"用户协议\"和\"隐私协议\"";
//
//
//    UIButton *btnUser = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX + 90, iTopY, 60, 20)];
//    [self.view addSubview:btnUser];
//    //btnUser.backgroundColor = [UIColor yellowColor];
//    [btnUser addTarget:self action:@selector(actionUser) forControlEvents:UIControlEventTouchUpInside];
//
//    iLeftX += 90 + btnUser.width +10;
//    UIButton *btnSecret = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 60, 20)];
//    [self.view addSubview:btnSecret];
//    //btnSecret.backgroundColor = [UIColor blueColor];
//    [btnSecret addTarget:self action:@selector(actionSecret) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

#pragma mark  ---  action
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}


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


-(void) actionDL
{
    if (![fieldPhone.text isMobileNumber])
     {
        [MBProgressHUD showErrorWithStatus:@"请输入正确的手机号码" toView:self.view];
        return;
     }
    
    if (fieldCode.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
     }
    
}

#pragma mark --- 网络通讯
-(void)getSMSFrist
{
    smsTokenId = @"";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSmsToken];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = fieldPhone.text;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 998;
    [operation start];
}


-(void)getSMSSecond
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGnologin];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = fieldPhone.text;
    parmas[@"smsTokenId"] = smsTokenId;
    NSString *strTemp = [NSString stringWithFormat:@"%@&%@",smsTokenId,fieldPhone.text];
    parmas[@"smsEnc"] = [strTemp stringTGWToMD5];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 999;
    [operation start];
}


//绑定手机
-(void)bindPhoneUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"telephone"] = fieldPhone.text;
    params[@"randomNo"] = fieldCode.text;
    params[@"unionid"] = self.unionid;
    // 渠道来源
    params[@"sourceType"] = @"tgwsc";
    params[@"downloadSource"] = @"AppStore";
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@fx/cust/app/wxLoginBind",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    if (998 == operation.tag )
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            smsTokenId =  [NSString stringWithFormat:@"%@", dic[@"smsTokenId"]];
            [self getSMSSecond];
         }
     }
    if (1000 == operation.tag)
     {
        //登陆成功,发送通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
        //跳转首页
        [[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
     }

}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


@end

//
//  LoginViewController.m
//  XXXD
//
//  Created by xxjr03 on 2017/12/23.
//  Copyright © 2017年 xxjr03. All rights reserved.
//

#import "LoginViewController.h"

#import "BindPhoneViewController.h"
#import "IdentifyAlertView.h"

@interface LoginViewController ()
{

    UIView *_YSAleartView;
    NSString *smsTokenId;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;//手机号
@property (weak, nonatomic) IBOutlet UITextField *VerifyTextField;//验证码
@property (weak, nonatomic) IBOutlet UIButton *VerifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeTreatyBtn;
@property (weak, nonatomic) IBOutlet UIView *wxLoginView;

@property(nonatomic, strong)NSString *unionid;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //判断是否安装微信
    [self isWeiXin];
    
    [self.phoneTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.VerifyTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
//    //第一次打开该版本弹出隐私协议
//     if ([ToolsUtlis isAppFirstLoaded]){
//         [self YSAleartViewUI];
//     }
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}

//判断是否安装微信隐藏按钮
- (void) isWeiXin{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ) {
        self.wxLoginView.hidden = YES;
    }else{
        self.wxLoginView.hidden = NO;
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)agreetreaty:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
}



- (IBAction)treaty_YH:(UIButton *)sender {
    [self.view endEditing:YES];
    [CCWebViewController showWithContro:self withUrlStr:@"https://phone.xxjr.com/xxapp/protocol/xxzsProtocol.html" withTitle:@"小小助手用户协议"];
}

- (IBAction)treaty_YS:(UIButton *)sender {
    [self.view endEditing:YES];
    [CCWebViewController showWithContro:self withUrlStr:@"https://phone.xxjr.com/xxapp/protocol/xxzsPrivacy.html" withTitle:@"小小助手隐私协议"];
}

//验证码登录
- (IBAction)LoginBtn:(id)sender {
    [self.view endEditing:YES];
    if (!self.loginBtn.selected) {
        return;
    }
    if (!self.agreeTreatyBtn.selected) {
        [MBProgressHUD showErrorWithStatus:@"请阅读并同意协议" toView:self.view];
        return;
    }
    //验证码登录
    if (![_phoneTextField.text isMobileNumber]) {
        [MBProgressHUD showErrorWithStatus:[LanguageManager wrongMobileNumberTipsString] toView:self.view];
        return;
    }else if (_VerifyTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
    }else {
        [self VFLoginUrl];
    }
    
}

//微信登录
- (IBAction)WXLogin:(id)sender {
    [self.view endEditing:YES];
    if (!self.agreeTreatyBtn.selected) {
        [MBProgressHUD showErrorWithStatus:@"请阅读并同意协议" toView:self.view];
        return;
    }
    
    [[DDGShareManager shareManager] loginType:2 block:^(id obj){
        NSDictionary *dic = (NSDictionary *)obj;
        self.unionid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unionid"]];
        if (self.unionid.length > 0) {
            [self WXLoginUrl:self.unionid];
        }
    } view:self.view];
    
}


//获取验证码
- (IBAction)VerifyBtn:(UIButton *)sender {
    if (![ToolsUtlis isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
    if (![_phoneTextField.text isMobileNumber]) {
        [MBProgressHUD showErrorWithStatus:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.VerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.VerifyBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.VerifyBtn setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                self.VerifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    [self getSMSFrist];
}

-(void)getSMSFrist{
    smsTokenId = @"";
    [MBProgressHUD showHUDAddedTo:self.view];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSmsToken];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = self.phoneTextField.text;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 998;
}

-(void)getSMSSecond{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGnologin];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = self.phoneTextField.text;
    parmas[@"smsTokenId"] = smsTokenId;
    NSString *strTemp = [NSString stringWithFormat:@"%@&%@",smsTokenId,self.phoneTextField.text];
    parmas[@"smsEnc"] = [strTemp stringTGWToMD5];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  } failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 999;
}

//验证码登陆
-(void)VFLoginUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"telephone"] = self.phoneTextField.text;
    params[@"randomNo"] = self.VerifyTextField.text;
    // 渠道来源
    params[@"sourceType"] = @"AppStore";
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userKJLoginInfoAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

//微信登录
- (void)WXLoginUrl:(NSString *)unionid{
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"unionid"] = unionid;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userWXLoginInfoAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                       [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1002;
    [operation start];
}

//获取用户信息
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
     [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (operation.tag == 998){
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic){
            smsTokenId =  [NSString stringWithFormat:@"%@", dic[@"smsTokenId"]];
            [self getSMSSecond];
         }
     }else if (operation.tag == 999){
        [MBProgressHUD showSuccessWithStatus:@"获取验证码成功" toView:self.view];
     }else if (operation.tag == 1001) {
        //验证码登录
        //登陆成功,发送通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
        //跳转首页
        [[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
    }else if (operation.tag == 1002) {
        //微信登录
        if ([[operation.jsonResult.attr objectForKey:@"unbind"] intValue] == 1) {
            //新用户绑定手机号
            BindPhoneViewController *ctl = [[BindPhoneViewController alloc]init];
            ctl.unionid = _unionid;
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            //登陆成功,发送通知更新用户信息
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
            //跳转首页
            [[DDGUserInfoEngine engine] finishDoBlock];
            [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
        }
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

#pragma mark- 监听输入框内容改变按钮颜色
-(void)textFieldTextChange:(UITextField *)textField{
    if (self.phoneTextField.text.length != 0 && self.VerifyTextField.text.length != 0) {
        self.loginBtn.selected = YES;
        self.loginBtn.backgroundColor = [ResourceManager mainColor];
    }else{
        self.loginBtn.selected = NO;
        self.loginBtn.backgroundColor = UIColorFromRGB(0xC4BAB1);
    }
}


#pragma mark 隐私协议布局
-(void)YSAleartViewUI{
    [_YSAleartView  removeFromSuperview];
    
    _YSAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_YSAleartView];
    _YSAleartView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 251 * ScaleSize)/2, (SCREEN_HEIGHT - 383 * ScaleSize)/2, 251 * ScaleSize, 383 * ScaleSize)];
    [_YSAleartView addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"Tab_1-32"];
    imgView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, imgView.bounds.size.width, 60)];
    [imgView addSubview:titleLabel];
    titleLabel.textColor = [ResourceManager color_1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"天狗口袋隐私协议";
    
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(titleLabel.frame), imgView.bounds.size.width - 60, 200)];
    [imgView addSubview:subTitleLabel];
    subTitleLabel.textColor = [ResourceManager color_1];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.font = [UIFont systemFontOfSize:13];
    subTitleLabel.text = @"感谢您下载天狗口袋APP,当您开始使用本软件时，我们可能会对您的部分个人信息收集、使用和分享。\n\n请您仔细阅读《天狗口袋隐私协议》并确认了解我们对您个人信息的处理规则。\n\n开始使用我们的软件和服务，我们尽全力保护您的个人信息安全。";
    [subTitleLabel sizeToFit];
    
    UILabel *treatyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(subTitleLabel.frame) + 25, 115, 30)];
    [imgView addSubview:treatyLabel];
    treatyLabel.textColor = [ResourceManager color_6];
    treatyLabel.font = [UIFont systemFontOfSize:12];
    treatyLabel.text = @"点击按钮即表示同意";
    
    UIButton *treatyBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(treatyLabel.frame) - 10, CGRectGetMinY(treatyLabel.frame), 125, 30)];
    [imgView addSubview:treatyBtn];
    [treatyBtn setTitle:@"《天狗口袋隐私协议》" forState:UIControlStateNormal];
    treatyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [treatyBtn setTitleColor:UIColorFromRGB(0x3f9dff) forState:UIControlStateNormal];
    [treatyBtn addTarget:self action:@selector(treaty) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(treatyLabel.frame) + 10, imgView.bounds.size.width - 60, 40)];
    [imgView addSubview:agreeBtn];
    agreeBtn.backgroundColor = UIColorFromRGB(0x3f9dff);
    agreeBtn.layer.cornerRadius = 40/2;
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *disaccordBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(agreeBtn.frame) + 10, imgView.bounds.size.width - 60, 40)];
    [imgView addSubview:disaccordBtn];
    disaccordBtn.backgroundColor = [UIColor whiteColor];
    disaccordBtn.layer.cornerRadius = 40/2;
    disaccordBtn.layer.borderWidth = 0.5;
    disaccordBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    [disaccordBtn setTitle:@"不同意" forState:UIControlStateNormal];
    disaccordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [disaccordBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [disaccordBtn addTarget:self action:@selector(disaccord) forControlEvents:UIControlEventTouchUpInside];
}

//隐私协议
- (void)treaty {
    NSString *url = [NSString stringWithFormat:@"%@tgwproject/AgreePrivacy",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"隐私协议"];
}

//同意隐私协议
-(void)agree{
     [_YSAleartView removeFromSuperview];
    
    //更新第一次打开该版本信息
    [ToolsUtlis saveBundleVersion];
   
}

//不同意隐私协议
-(void)disaccord{
    //退出代码
    exit(0);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

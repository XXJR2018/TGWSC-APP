//
//  BindPhoneViewController.m
//  XXJR
//
//  Created by xxjr03 on 2017/12/28.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "BindPhoneViewController.h"

#import "IdentifyAlertView.h"

@interface BindPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;//手机号
@property (weak, nonatomic) IBOutlet UITextField *VerifyTextField;//验证码
@property (weak, nonatomic) IBOutlet UIButton *VerifyBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutNextBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutNextBtnWidth;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutNaviBarViewWithTitle:@"绑定手机号"];
    self.layoutNextBtnWidth.constant = 290 * ScaleSize;
    self.layoutNextBtnHeight.constant = 45  * ScaleSize;

    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}

//获取验证码
- (IBAction)VerifyBtn:(UIButton *)sender {
    if (![ToolsUtlis isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
    if ([_phoneTextField.text isMobileNumber]) {
        IdentifyAlertView * alert = [[IdentifyAlertView alloc] initWithTitle:@"图形验证码"
                                                                CancelButton:@"确定"
                                                                    OkButton:@"取消"];
        alert.parentVC = self;
        alert.strPhone = _phoneTextField.text;
        alert.strRequestURL = @"fx/smsAction/newNologin/wxBindTel";
        [alert show];
    }else{
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
}

//绑定手机
- (IBAction)NextUrl:(id)sender {
    [self.view endEditing:YES];
    if (![_phoneTextField.text isMobileNumber]) {
        [MBProgressHUD showErrorWithStatus:[LanguageManager wrongMobileNumberTipsString] toView:self.view];
        return;
    }else if (_VerifyTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
    }else {
        [self bindPhoneUrl];
    }
}

//绑定手机
-(void)bindPhoneUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"telephone"] = _phoneTextField.text;
    params[@"randomNo"] = _VerifyTextField.text;
    params[@"unionid"] = self.unionid;
    // 渠道来源
    params[@"sourceType"] = @"xxzqios";
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
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    //登陆成功,发送通知更新用户信息
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
    //跳转首页
    [[DDGUserInfoEngine engine] finishDoBlock];
    [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
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

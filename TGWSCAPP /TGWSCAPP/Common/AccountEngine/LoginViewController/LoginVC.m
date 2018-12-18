//
//  LoginVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/12/11.
//  Copyright © 2018 Cary. All rights reserved.
//

#import "LoginVC.h"
#import "CCWebViewController.h"
#import "BindPhoneVC.h"

@interface LoginVC ()
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

@property(nonatomic, strong)NSString *unionid;

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
    labelXY = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX , iTopY, SCREEN_WIDTH - iLeftX -15, 20)];
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
    
    [self getSMSFrist];
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
    //BindPhoneVC  *VC = [[BindPhoneVC alloc] init];
    //[self.navigationController pushViewController:VC animated:YES];
    
    [self.view endEditing:YES];
    if (!isCheck) {
        [MBProgressHUD showErrorWithStatus:@"请阅读并同意用户协议" toView:self.view];
        return;
    }
    
    [[DDGShareManager shareManager] loginType:2 block:^(id obj){
        NSDictionary *dic = (NSDictionary *)obj;
        self.unionid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unionid"]];
        if (self.unionid.length > 0) {
            [self wxLoginUrl:self.unionid];
        }
    } view:self.view];
    
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
    
    [self loginUrl];
//    //跳转首页
//    //[self.navigationController popToRootViewControllerAnimated:YES];
//    [[DDGUserInfoEngine engine] finishDoBlock];
//    [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
    
}


#pragma mark --- 网络通讯
// 手机登录
-(void)loginUrl
{
     [MBProgressHUD showHUDAddedTo:self.view];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"telephone"] = fieldPhone.text;
    params[@"randomNo"] =  fieldCode.text;
    // 渠道来源
    params[@"sourceType"] = @"AppStore";
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userKJLoginInfoAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void)getSMSFrist
{
    smsTokenId = @"";
     [MBProgressHUD showHUDAddedTo:self.view];
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
     [MBProgressHUD showHUDAddedTo:self.view];
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


//微信登录
- (void)wxLoginUrl:(NSString *)unionid{
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"unionid"] = unionid;
    //渠道来源
    params[@"sourceType"] = @"AppStore";
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userWXLoginInfoAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (operation.tag == 998)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            smsTokenId =  [NSString stringWithFormat:@"%@", dic[@"smsTokenId"]];
            [self getSMSSecond];
         }
        
     }
    else if (operation.tag == 1000) {
        
        //跳转首页
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
        
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

@end

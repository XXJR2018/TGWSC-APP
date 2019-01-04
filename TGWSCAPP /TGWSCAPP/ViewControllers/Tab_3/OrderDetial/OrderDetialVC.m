//
//  OrderDetialVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/3.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "OrderDetialVC.h"

@interface OrderDetialVC ()
{
    UIScrollView  *scView;
}
@end

@implementation OrderDetialVC

#pragma mark ---  lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initData];
    
    [self layoutNaviBarViewWithTitle:@"确认订单"];
    
    [self getUIDataFromWeb];
}

-(void) initData
{
    //_dicToWeb = [[NSMutableDictionary alloc] init];
}

#pragma mark --- 布局UI
-(void) layoutUI:(NSDictionary*) dicUI
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 1000);
    scView.pagingEnabled = NO;
    //scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];//[ResourceManager viewBackgroundColor];
}

#pragma mark --- 网络请求
-(void) getUIDataFromWeb
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params = _dicToWeb;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLsingleOrderInfo];
    if (2 == _iType)
     {
        strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLbatchOrderInfo];
     }
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (operation.tag == 1000)
     {
     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}



@end

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
    
    NSDictionary *dicOfUI;
    NSArray *arrOfUI;
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
    dicOfUI = nil;
    arrOfUI = nil;
}

#pragma mark --- 布局UI
-(void) layoutUI:(NSDictionary*) dicValue  andArr:(NSArray*)arrValue
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 1000);
    scView.pagingEnabled = NO;
    //scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];//[ResourceManager viewBackgroundColor];
    
    int iTopY = 0;
    int iLeftX = 0;
    
    UIImageView *imgCiaoTiao = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 3)];
    [scView addSubview:imgCiaoTiao];
    imgCiaoTiao.image = [UIImage imageNamed:@"od_caitiao"];
    
    iTopY += imgCiaoTiao.height;
    
    
    
//    // 画虚线
//    UIImageView * lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 100, SCREEN_WIDTH, 1)];
//    [scView addSubview:lineView1];
//    lineView1.image = [ToolsUtlis imageWithLineWithImageView:lineView1];
}

#pragma mark --- 网络请求
-(void) getUIDataFromWeb
{
    dicOfUI = nil;
    arrOfUI = nil;
    
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
        dicOfUI = operation.jsonResult.attr;
        arrOfUI = operation.jsonResult.rows;
        [self layoutUI:dicOfUI andArr:arrOfUI];
     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}




@end

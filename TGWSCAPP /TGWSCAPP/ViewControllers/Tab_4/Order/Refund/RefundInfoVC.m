//
//  RefundInfoVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundInfoVC.h"

@interface RefundInfoVC ()

@end

@implementation RefundInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"退款详情"];
    
    [self getUIDataFromWeb];
    
}


#pragma mark --- 布局UI
-(void) layoutUI:(NSDictionary*) dicValue
{
    //处理状态(0-待处理 1-商家待收货 2-同意退款 3-退款成功 4-商家拒绝退款 5-交易关闭 6-可重新申请)
}


#pragma mark  ---  网络请求
-(void)getUIDataFromWeb{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"refundNo"] = _dicParams[@"refundNo"];
    params[@"subOrderNo"] = _dicParams[@"subOrderNo"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kURLrefundDetailInfo];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    operation.tag  = 1000;
    [operation start];
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (1000 == operation.tag)
     {
        NSDictionary *dicUI = operation.jsonResult.attr;
        if (dicUI)
         {
            
         }
     }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


@end

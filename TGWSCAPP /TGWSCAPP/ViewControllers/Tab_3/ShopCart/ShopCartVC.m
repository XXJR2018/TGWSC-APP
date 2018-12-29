//
//  ShopCartVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/29.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ShopCartVC.h"

@interface ShopCartVC ()

@end

@implementation ShopCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"购物车"];
    
    [self orderCartList];
}


#pragma mark --- 网络通讯
// 购物车列表
-(void) orderCartList
{
    [MBProgressHUD showHUDAddedTo:self.view];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //params[@"goodsCode"] = _shopModel.strGoodsCode;
    //params[@"num"] = @(iSelCount);
    //params[@"skuCode"] = strSKUCode;
    
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLorderCartList];
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
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}

@end

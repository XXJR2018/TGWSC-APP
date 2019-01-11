//
//  RefundInfoVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundInfoVC.h"

@interface RefundInfoVC ()
{
    UIScrollView *scView;
    
    UIView *viewHead; // 退款头部
    
    UIView *viewShop;  // 退款商品信息
    
    
    NSDictionary *dicUI;
}
@end

@implementation RefundInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"退款详情"];

    [self initData];
    
    [self getUIDataFromWeb];
    
}

-(void) initData
{
    dicUI = [[NSDictionary alloc] init];
}

#pragma mark --- 布局UI
-(void) layoutUI:(NSDictionary*) dicValue
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 100)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 500);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    [self layoutHead:dicValue];
    
}


-(void) layoutHead:(NSDictionary*) dicValue
{
    viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    [scView addSubview:viewHead];
    viewHead.backgroundColor = [UIColor whiteColor];
    
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [viewHead addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    
    int iTopY = 15;
    int iLeftX = 10;
    UILabel *labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 20)];
    [viewHead addSubview:labelStatus];
    labelStatus.textColor = [ResourceManager priceColor];
    labelStatus.font = [UIFont systemFontOfSize:14];
    labelStatus.text = dicValue[@"serverStatusDesc"];
    
    
    iTopY += labelStatus.height + 10;
    UILabel *labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 46)];
    [viewHead addSubview:labelDesc];
    //labelDesc.backgroundColor = [UIColor yellowColor];
    labelDesc.textColor = [ResourceManager color_1];
    labelDesc.font = [UIFont systemFontOfSize:12];
    labelDesc.numberOfLines = 0;
    labelDesc.text = @"";
    
    int iServerStatus = [dicValue[@"serverStatus"] intValue];
    //iServerStatus = 3;
    //处理状态(0-待处理 1-商家待收货 2-同意退款（需要填写物流） 3-退款成功 4-商家拒绝退款 5-交易关闭 6-可重新申请)
    
    //0-待处理  1-商家待收货 2-同意退款 3 -同意退款退货 4-商家收到货 5-退款成功 6-退款失败 7-商家拒绝退款 8-取消申请(交易关闭)
    if (0 == iServerStatus)
     {
        labelStatus.text = @"等待商家处理退款申请";
        labelDesc.text = dicValue[@"serverDesc"]? dicValue[@"serverDesc"]:@"如果商家同意:退款金额将原路返回支付账号\n如果商家拒绝并已经发货：请联系商家沟通后再次提交申请";
     }
    else if (1 == iServerStatus)
     {
        labelStatus.text = @"商家等待收货";
        labelDesc.text = dicValue[@"serverDesc"];
     }
    else if (2 == iServerStatus)
     {
        labelStatus.text = @"商家同意退款，请退货给商家";
        labelDesc.text = dicValue[@"receiveAddrDtl"]? [NSString stringWithFormat:@"收货地址： %@", dicValue[@"receiveAddrDtl"]]:@"请和商家联系，获取退货地址";;
     }
    else if (3 == iServerStatus)
     {
        labelStatus.text = @"退款成功";
        
        NSString *strText =  [NSString stringWithFormat:@"退款时间:%@\n退款金额:%@\n退款金额将按原路返回支付账户。",dicValue[@"createTime"],dicValue[@"refundTotalAmt"]];
        
        labelDesc.text = strText;
     }
    else if (4 == iServerStatus)
     {
        labelStatus.text = @"商家拒绝退款";
        labelDesc.text =  dicValue[@"serverDesc"]? [NSString stringWithFormat:@"%@", dicValue[@"serverDesc"]]:@"请与商家沟通交流后再次提交申请";
     }
    else if (5 == iServerStatus)
     {
        labelStatus.text = @"退款关闭";
        labelDesc.text = dicValue[@"createTime"]? [NSString stringWithFormat:@"%@", dicValue[@"createTime"]]:@"";
     }
    
    
    
    
    
    
    
    
    
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
        dicUI = operation.jsonResult.attr;
        if (dicUI)
         {
            [self layoutUI:dicUI];
         }
     }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


@end

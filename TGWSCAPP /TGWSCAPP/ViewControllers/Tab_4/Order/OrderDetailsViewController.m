//
//  OrderDetailsViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/1/10.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "OrderDetailsViewController.h"

@interface OrderDetailsViewController ()
{
    UIScrollView *_scView;
    CGFloat _currentHeight;
    
    NSDictionary *_orderDataDic;
    NSInteger _status;
}
@end

@implementation OrderDetailsViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = self.orderNo;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/myOrder/detailInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}


#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (operation.jsonResult.attr.count > 0) {
        _orderDataDic = operation.jsonResult.attr;
        _status = [[_orderDataDic objectForKey:@"status"] intValue];
    }
    if (operation.jsonResult.rows.count > 0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:operation.jsonResult.rows];
    }
    
    [self layoutUI];
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订单详情"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"订单详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"订单详情"];
}

-(void)layoutUI{
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_scView];
    _scView.backgroundColor = [ResourceManager viewBackgroundColor];
    _scView.bounces = NO;
    _scView.pagingEnabled = NO;
    _scView.showsVerticalScrollIndicator = NO;
    
    [self headerViewUI];
    [self centreViewUI];
    [self footerViewUI];
    _scView.contentSize = CGSizeMake(0, _currentHeight);
}

#pragma mark---头部控件布局
-(void)headerViewUI{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    [_scView addSubview:headerView];
    
    if ([_orderDataDic objectForKey:@"processFlag"]) {
        NSArray *titleArr = @[@"下单",@"付款",@"商家确认",@"发货",@"完成"];
        NSInteger processFlag = [[_orderDataDic objectForKey:@"processFlag"] intValue];
        for (int i = 0; i < titleArr.count; i++) {
            UIView *radiusView = [[UIView alloc]initWithFrame:CGRectMake(25 + (SCREEN_WIDTH - 50)/4 * i - 6/2, 20, 8, 8)];
            [headerView addSubview:radiusView];
            radiusView.backgroundColor = [ResourceManager color_5];
            radiusView.layer.cornerRadius = 8/2;
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(radiusView.frame) - 40, CGRectGetMaxY(radiusView.frame) + 5, 80, 25)];
            [headerView addSubview:titleLabel];
            titleLabel.textColor = [ResourceManager color_6];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = titleArr[i];
            
            if (i < titleArr.count - 1) {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(radiusView.frame), CGRectGetMidY(radiusView.frame) - 1/2, (SCREEN_WIDTH - 50)/4, 0.5)];
                [headerView addSubview:lineView];
                lineView.backgroundColor = [ResourceManager color_5];
                if (i < processFlag) {
                    lineView.backgroundColor = [ResourceManager mainColor];
                }
            }
            if (i <= processFlag) {
                titleLabel.textColor = [ResourceManager mainColor];
                UIImageView *statusImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(radiusView.frame) - 15/2, CGRectGetMidY(radiusView.frame) - 15/2, 15, 15)];
                [headerView addSubview:statusImgView];
                statusImgView.image = [UIImage imageNamed:@"Tab_4-29"];
            }
            _currentHeight = CGRectGetMaxY(titleLabel.frame) + 10;
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, _currentHeight, SCREEN_WIDTH - 20, 0.5)];
        [headerView addSubview:lineView];
        lineView.backgroundColor = [ResourceManager color_5];
    }
    
    UILabel *userInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _currentHeight + 10, 200, 30)];
    [headerView addSubview:userInfoLabel];
    userInfoLabel.textColor = [ResourceManager color_1];
    userInfoLabel.font = [UIFont systemFontOfSize:14];
    userInfoLabel.text = [NSString stringWithFormat:@"%@  %@",[_orderDataDic objectForKey:@"receiveName"],[_orderDataDic objectForKey:@"hideReceiveTel"]];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(userInfoLabel.frame), SCREEN_WIDTH - 120, 35)];
    [headerView addSubview:addressLabel];
    addressLabel.numberOfLines = 2;
    addressLabel.textColor = [ResourceManager color_6];
    addressLabel.font = [UIFont systemFontOfSize:13];
    addressLabel.text = [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"receiveAddr"]];
    
    if (_status == 0 || _status == 1) {
        UIButton *changeAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, CGRectGetMinY(userInfoLabel.frame) + 5, 75, 28)];
        [headerView addSubview:changeAddressBtn];
        changeAddressBtn.layer.borderWidth = 0.5;
        changeAddressBtn.layer.borderColor = [ResourceManager color_5].CGColor;
        changeAddressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [changeAddressBtn setTitle:@"修改地址" forState:UIControlStateNormal];
        [changeAddressBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        [changeAddressBtn addTarget:self action:@selector(changeAddress) forControlEvents:UIControlEventTouchUpInside];
    }
    
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(addressLabel.frame) + 10);
    _currentHeight = CGRectGetMaxY(headerView.frame) + 10;
}

#pragma mark---中间控件布局
-(void)centreViewUI{
    UIView *centreView = [[UIView alloc]init];
    centreView.backgroundColor = [UIColor whiteColor];
    [_scView addSubview:centreView];
    
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:14];
    UIFont *font_2 = [UIFont systemFontOfSize:13];
    
    UILabel *wlxxLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    [centreView addSubview:wlxxLabel];
    wlxxLabel.textColor = color_2;
    wlxxLabel.font = font_1;
    wlxxLabel.text = @"物流信息：";
    
    UILabel *wlxxInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wlxxLabel.frame), 0, SCREEN_WIDTH - CGRectGetMaxX(wlxxLabel.frame) - 20, 40)];
    [centreView addSubview:wlxxInfoLabel];
    wlxxInfoLabel.textColor = color_1;
    wlxxInfoLabel.font = font_1;
    wlxxInfoLabel.text = [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"logisticsDesc"]];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(wlxxLabel.frame), SCREEN_WIDTH - 20, 0.5)];
    [centreView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *dic = self.dataArray[i];
        UIImageView *productImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 15 + 90 * i, 70, 70)];
        [centreView addSubview:productImgView];
        productImgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [productImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"goodsUrl"]]];
        
        UILabel *productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(productImgView.frame) + 10, CGRectGetMinY(productImgView.frame) + 5, 200, 20)];
        [centreView addSubview:productNameLabel];
        productNameLabel.font = font_1;
        productNameLabel.textColor = color_1;
        productNameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsName"]];
        
         UILabel *productDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(productImgView.frame) + 10, CGRectGetMaxY(productNameLabel.frame) + 5, 200, 20)];
        [centreView addSubview:productDescLabel];
        productDescLabel.font = font_2;
        productDescLabel.textColor = color_2;
        productDescLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"skuDesc"]];
        
        UILabel *productPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMinY(productImgView.frame) + 5, 150, 20)];
        [centreView addSubview:productPriceLabel];
        productPriceLabel.textAlignment = NSTextAlignmentRight;
        productPriceLabel.font = font_1;
        productPriceLabel.textColor = color_2;
        productPriceLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
        
        UILabel *productNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMaxY(productPriceLabel.frame) + 5, 150, 20)];
        [centreView addSubview:productNumLabel];
        productNumLabel.textAlignment = NSTextAlignmentRight;
        productNumLabel.font = font_2;
        productNumLabel.textColor = color_2;
        productNumLabel.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"num"]];
        
         centreView.frame = CGRectMake(0, _currentHeight, SCREEN_WIDTH, CGRectGetMaxY(productImgView.frame) + 20);
    }
    
    _currentHeight = CGRectGetMaxY(centreView.frame) + 10;
}

#pragma mark---底部控件布局
-(void)footerViewUI{
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor whiteColor];
    [_scView addSubview:footerView];
    
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:13];
    CGFloat _footerHeight = 10;
    if ([_orderDataDic objectForKey:@"remark"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"remark"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight, 150, 20)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"买家留言";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight, 250, 20)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = color_1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"remark"]];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame) + 5;
    }
    
    if ([_orderDataDic objectForKey:@"orderNo"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"orderNo"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight, 150, 20)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"订单编号";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight, 200, 20)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = color_1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"orderNo"]];
        
        UIButton *copyExpressBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rightLabel.frame) + 5, _footerHeight, 45, 20)];
        [footerView addSubview:copyExpressBtn];
        copyExpressBtn.layer.borderWidth = 0.5;
        copyExpressBtn.layer.borderColor = [ResourceManager color_5].CGColor;
        copyExpressBtn.titleLabel.font = font_1;
        [copyExpressBtn setTitle:@"复制" forState:UIControlStateNormal];
        [copyExpressBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [copyExpressBtn addTarget:self action:@selector(copyExpress) forControlEvents:UIControlEventTouchUpInside];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame);
    }
    
    if ([_orderDataDic objectForKey:@"createTime"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"createTime"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight, 150, 20)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"下单日期";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight, 250, 20)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = color_1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"createTime"]];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame) ;
    }
    
    if ([_orderDataDic objectForKey:@"payTime"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"payTime"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight, 150, 20)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"付款日期";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight, 250, 20)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = color_1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"payTime"]];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame);
    }
    
    UIView *lineViewX_1 = [[UIView alloc]initWithFrame:CGRectMake(10, _footerHeight  + 5, SCREEN_WIDTH - 20, 0.5)];
    [footerView addSubview:lineViewX_1];
    lineViewX_1.backgroundColor = [ResourceManager color_5];
    
    if ([_orderDataDic objectForKey:@"balanceAmt"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"balanceAmt"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight + 15, 150, 20)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"余额";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight + 15, 250, 20)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = color_1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"-￥%@",[_orderDataDic objectForKey:@"balanceAmt"]];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame);
    }
    
    if ([_orderDataDic objectForKey:@"promocardTotalAmt"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"promocardTotalAmt"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight, 150, 20)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"优惠券";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight, 250, 20)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = color_1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"-￥%@",[_orderDataDic objectForKey:@"promocardTotalAmt"]];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame);
    }
    
    if ([_orderDataDic objectForKey:@"receiveScore"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"receiveScore"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight, 150, 20)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"购买所得积分";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight, 250, 20)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = color_1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"-￥%@",[_orderDataDic objectForKey:@"receiveScore"]];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame);
    }
    
    if ([_orderDataDic objectForKey:@"payTypeText"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"payTypeText"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight, 150, 20)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"支付方式";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight, 250, 20)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = color_1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"payTypeText"]];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame);
    }
    
    if ([_orderDataDic objectForKey:@"goodsTotalAmt"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"goodsTotalAmt"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight, 150, 20)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"商品合计";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight, 250, 20)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = color_1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"￥%@",[_orderDataDic objectForKey:@"goodsTotalAmt"]];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame);
    }
    
    if ([_orderDataDic objectForKey:@"freightAmt"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"freightAmt"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight, 150, 20)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"运费";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight, 250, 20)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = color_1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"￥%@",[_orderDataDic objectForKey:@"freightAmt"]];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame);
    }
    
    UIView *lineViewX_2 = [[UIView alloc]initWithFrame:CGRectMake(10, _footerHeight + 10, SCREEN_WIDTH - 20, 0.5)];
    [footerView addSubview:lineViewX_2];
    lineViewX_2.backgroundColor = [ResourceManager color_5];
    
    if ([_orderDataDic objectForKey:@"payAmt"] && [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"payAmt"]].length > 0) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _footerHeight + 10, 150, 50)];
        [footerView addSubview:leftLabel];
        leftLabel.font = font_1;
        leftLabel.textColor = color_2;
        leftLabel.text = @"应付合计";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, _footerHeight + 10, 250, 50)];
        [footerView addSubview:rightLabel];
        rightLabel.font = font_1;
        rightLabel.textColor = UIColorFromRGB(0xB00000);
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = [NSString stringWithFormat:@"￥%@",[_orderDataDic objectForKey:@"payAmt"]];
        
        _footerHeight = CGRectGetMaxY(leftLabel.frame);
    }
    
    footerView.frame = CGRectMake(0, _currentHeight, SCREEN_WIDTH, _footerHeight);
    _currentHeight = CGRectGetMaxY(footerView.frame) + 10;
    
}

#pragma mark----- 修改地址
-(void)changeAddress{
    
}

-(void)copyExpress{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"orderNo"]];;
    if (pasteboard.string) {
        [MBProgressHUD showSuccessWithStatus:@"复制成功" toView:self.view];
    }
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

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
    
    UIButton *_agreeTreatyBtn;
    UIImageView *_moreImgView;
    UIButton *_moreAleartBtn;
}

@property(nonatomic, strong)UIButton *orderLeftBtn;      //订单左边按钮

@property(nonatomic, strong)UIButton *orderCentreBtn;    //订单中间按钮

@property(nonatomic, strong)UIButton *orderRightBtn;    //订单右边按钮

@property(nonatomic, strong)UIButton *moreBtn;          //更多按钮

@property(nonatomic, strong)UILabel *countDownLabel;       //倒计时

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
    if (operation.jsonResult.attr.count > 0 && operation.jsonResult.rows.count > 0) {
        _orderDataDic = operation.jsonResult.attr;
        _status = [[_orderDataDic objectForKey:@"status"] intValue];
        _status = 6;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:operation.jsonResult.rows];
        [self layoutUI];
    }
    
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
    [self orderBtnUI];
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
         NSString *orderStatusDesc = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderStatusDesc"]];
        
        UIImageView *productImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 15 + 90 * i, 70, 70)];
        [centreView addSubview:productImgView];
        productImgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [productImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"goodsUrl"]]];
        
        if (orderStatusDesc.length > 0) {
             productImgView.frame = CGRectMake(10, CGRectGetMaxY(lineView.frame) + 15 + 105 * i, 70, 70);
        }
        
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
        
        if (orderStatusDesc.length > 0) {
            CGFloat refundHeight = 70;
            if (orderStatusDesc.length > 4) {
                refundHeight = 70 + (orderStatusDesc.length - 4) * 10;
            }
            UIButton *refundBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - refundHeight - 10, CGRectGetMaxY(productNumLabel.frame) + 10, refundHeight, 25)];
            [centreView addSubview:refundBtn];
            refundBtn.layer.borderWidth = 0.5;
            refundBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
            refundBtn.titleLabel.font = font_2;
            [refundBtn setTitle:orderStatusDesc forState:UIControlStateNormal];
            [refundBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
            [refundBtn addTarget:self action:@selector(refund) forControlEvents:UIControlEventTouchUpInside];
            if ([[dic objectForKey:@"orderStatus"] intValue] == 10) {
                refundBtn.layer.borderColor = UIColorFromRGB(0xB00000).CGColor;
                [refundBtn setTitleColor:UIColorFromRGB(0xB00000) forState:UIControlStateNormal];
            }
            
            if (i < self.dataArray.count -1) {
                UIView *productLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(productImgView.frame) + 95, SCREEN_WIDTH, 0.5)];
                [centreView addSubview:productLineView];
                productLineView.backgroundColor = [ResourceManager color_5];
            }
        }
       
         centreView.frame = CGRectMake(0, _currentHeight, SCREEN_WIDTH, CGRectGetMaxY(productImgView.frame) + 30);
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
        rightLabel.text = [NSString stringWithFormat:@"%@积分",[_orderDataDic objectForKey:@"receiveScore"]];
        
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

-(void)orderBtnUI{
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:13];
    
    if (_currentHeight + 90 < SCREEN_HEIGHT - NavHeight) {
        _currentHeight = SCREEN_HEIGHT - NavHeight - 90;
    }
    if (_status == 0 || _status == 2) {
        _agreeTreatyBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, _currentHeight, 20, 20)];
        [_scView addSubview:_agreeTreatyBtn];
        [_agreeTreatyBtn setImage:[UIImage imageNamed:@"Tab_4-31"] forState:UIControlStateNormal];
        [_agreeTreatyBtn setImage:[UIImage imageNamed:@"Tab_4-32"] forState:UIControlStateSelected];
        _agreeTreatyBtn.selected = YES;
        [_agreeTreatyBtn addTarget:self action:@selector(agreeTreaty:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_agreeTreatyBtn.frame) + 5, CGRectGetMinY(_agreeTreatyBtn.frame), 55, 20)];
        [_scView addSubview:agreeLabel];
        agreeLabel.font = [UIFont systemFontOfSize:12];
        agreeLabel.textColor = color_2;
        agreeLabel.text = @"我已同意";
        
        UIButton *treatyBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(agreeLabel.frame) - 10, CGRectGetMinY(_agreeTreatyBtn.frame), 145, 20)];
        [_scView addSubview:treatyBtn];
        [treatyBtn setTitle:@"《天狗窝商城服务协议》" forState:UIControlStateNormal];
        [treatyBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        treatyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [treatyBtn addTarget:self action:@selector(treaty) forControlEvents:UIControlEventTouchUpInside];
        
        _currentHeight = CGRectGetMaxY(_agreeTreatyBtn.frame) + 10;
    }
    
    UIView *lineViewX = [[UIView alloc]initWithFrame:CGRectMake(0, _currentHeight, SCREEN_WIDTH, 0.5)];
    [_scView addSubview:lineViewX];
    lineViewX.backgroundColor = [ResourceManager color_5];
    
    UIView *orderBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineViewX.frame), SCREEN_WIDTH, 55)];
    [_scView addSubview:orderBtnView];
    orderBtnView.backgroundColor = [UIColor whiteColor];
    
    _currentHeight = CGRectGetMaxY(orderBtnView.frame);
    
    _orderLeftBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 240, 25/2, 70, 30)];
    [orderBtnView addSubview:_orderLeftBtn];
    _orderLeftBtn.tag = 100;
    _orderLeftBtn.layer.borderWidth = 0.5;
    _orderLeftBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    _orderLeftBtn.titleLabel.font = font_1;
    [_orderLeftBtn setTitleColor:color_1 forState:UIControlStateNormal];
    [_orderLeftBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _orderCentreBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_orderLeftBtn.frame) + 10, CGRectGetMinY(_orderLeftBtn.frame), 70, 30)];
    [orderBtnView addSubview:_orderCentreBtn];
    _orderCentreBtn.tag = 101;
    _orderCentreBtn.layer.borderWidth = 0.5;
    _orderCentreBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    _orderCentreBtn.titleLabel.font = font_1;
    [_orderCentreBtn setTitleColor:color_1 forState:UIControlStateNormal];
    [_orderCentreBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _orderRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_orderCentreBtn.frame) + 10, CGRectGetMinY(_orderLeftBtn.frame), 70, 30)];
    [orderBtnView addSubview:_orderRightBtn];
    _orderRightBtn.tag = 102;
    _orderRightBtn.layer.borderWidth = 0.5;
    _orderRightBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    _orderRightBtn.titleLabel.font = font_1;
    [_orderRightBtn setTitleColor:color_1 forState:UIControlStateNormal];
    [_orderRightBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 25/2, 60, 30)];
    [orderBtnView addSubview:_moreBtn];
    _moreBtn.tag = 103;
    _moreBtn.titleLabel.font = font_1;
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_moreBtn setTitleColor:color_1 forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _moreImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(orderBtnView.frame)  - 50, 86, 56)];
    [_scView addSubview:_moreImgView];
    _moreImgView.image = [UIImage imageNamed:@"Tab_4-33"];
    _moreImgView.userInteractionEnabled = YES;
    
    _moreAleartBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 86, 50)];
    [_moreImgView addSubview:_moreAleartBtn];
    _moreAleartBtn.tag = 104;
    _moreAleartBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_moreAleartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_moreAleartBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _moreImgView.hidden = YES;
    _orderLeftBtn.hidden = YES;
    _orderCentreBtn.hidden = YES;
    _orderRightBtn.hidden = YES;
    _moreBtn.hidden = YES;
    
    if (_status == 0 || _status == 2) {
        _orderCentreBtn.hidden = NO;
        _orderRightBtn.hidden = NO;
        [_orderCentreBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_orderRightBtn setTitle:@"付款" forState:UIControlStateNormal];
        _orderRightBtn.layer.borderColor = UIColorFromRGB(0xB00000).CGColor;
        _orderRightBtn.titleLabel.font = font_1;
        _orderRightBtn.backgroundColor = UIColorFromRGB(0xB00000);
        [_orderRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        NSString *countDownTime = [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"countDownTime"]];
        if (countDownTime.length > 0) {
            _countDownLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 55)];
            [orderBtnView addSubview:_countDownLabel];
            _countDownLabel.font = [UIFont systemFontOfSize:12];
            _countDownLabel.textColor = color_2;
            _countDownLabel.text = [NSString stringWithFormat:@"还有 %@ 交易关闭",[_orderDataDic objectForKey:@"countDownTime"]];
            [_orderRightBtn setTitle:[NSString stringWithFormat:@"付款 %@",[_orderDataDic objectForKey:@"countDownTime"]] forState:UIControlStateNormal];
            //倒计时
            [self countDown:countDownTime];
        }
        
    }
    
    if (_status == 1 || _status == 3) {
        _orderCentreBtn.hidden = NO;
        _orderRightBtn.hidden = NO;
        [_orderCentreBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [_orderRightBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    }
    
    if (_status == 4 || _status == 7) {
        _orderLeftBtn.hidden = NO;
        _orderCentreBtn.hidden = NO;
        _orderRightBtn.hidden = NO;
        [_orderLeftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_orderCentreBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [_orderRightBtn setTitle:@"再次购买" forState:UIControlStateNormal];
    }
    
    if (_status == 5) {
        _orderLeftBtn.hidden = NO;
        _orderCentreBtn.hidden = NO;
        _orderRightBtn.hidden = NO;
        _moreBtn.hidden = NO;
        [_orderLeftBtn setTitle:@"申请售后" forState:UIControlStateNormal];
        [_orderCentreBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_orderRightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }
    
    if (_status == 6) {
        _orderLeftBtn.hidden = NO;
        _orderCentreBtn.hidden = NO;
        _orderRightBtn.hidden = NO;
        _moreBtn.hidden = NO;
        [_orderLeftBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [_orderCentreBtn setTitle:@"申请售后" forState:UIControlStateNormal];
        [_orderRightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    }
    
    if (_status == 8) {
        _orderLeftBtn.hidden = NO;
        _orderCentreBtn.hidden = NO;
        _orderRightBtn.hidden = NO;
        [_orderLeftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_orderCentreBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [_orderRightBtn setTitle:@"再次购买" forState:UIControlStateNormal];
    }
    
}


#pragma mark----- 修改地址
-(void)changeAddress{
    
}

#pragma mark----- 底部按钮点击事件
-(void)orderTouch:(UIButton *)sender{
    switch (sender.tag) {
        case 100:{
             if (_status == 4 ||_status == 7 || _status == 8) {
                 //删除订单
                 self.deleteOrderBlock();
             }else if (_status == 5) {
                 //申请售后
                 
             }else if (_status == 6) {
                 //联系客服
                 
             }
        }break;
        case 101:{
            if (_status == 0 ||_status == 2) {
                //取消订单
                self.cancelOrderBlock();
            }else if (_status == 1 || _status == 3 || _status == 4 || _status == 7 || _status == 8) {
               //联系客服
                
            }else if (_status == 5) {
                //查看物流
                
            }else if (_status == 6) {
                //申请售后
                
            }
        }break;
        case 102:{
            if (_status == 0 ||_status == 2) {
                //付款
                
            }else if (_status == 1 || _status == 3) {
                //申请售后
                
            }else if (_status == 4 || _status == 7 || _status == 8) {
                //再次购买
                self.againShopBlock();
            }else if (_status == 5) {
                //确认收货
                self.confirmGoodsBlock();
            }else if (_status == 6) {
                //查看物流
                
            }
        }break;
        case 103:{
            _moreBtn.selected = !_moreBtn.selected;
            if (_moreBtn.selected) {
                _moreImgView.hidden = NO;
                //更多
                if (_status == 5) {
                    [_moreAleartBtn setTitle:@"联系客服" forState:UIControlStateNormal];
                }else  if (_status == 6) {
                    [_moreAleartBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                }
            }else{
                 _moreImgView.hidden = YES;
            }
        }break;
        case 104:{
            if (_status == 5) {
                //联系客服
               
            }else  if (_status == 6) {
                //删除订单
                self.deleteOrderBlock();
            }
        }break;
        default:
            break;
    }
}

#pragma mark----- 跳转退款详情页面
-(void)refund{
    
}

-(void)agreeTreaty:(UIButton *)sender{
    sender.selected = !sender.selected;
}

//天狗窝商城服务协议
-(void)treaty{
    [CCWebViewController showWithContro:self withUrlStr:@"https://phone.xxjr.com/xxapp/protocol/xxzsPrivacy.html" withTitle:@"天狗窝商城服务协议"];
}

-(void)copyExpress{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@",[_orderDataDic objectForKey:@"orderNo"]];;
    if (pasteboard.string) {
        [MBProgressHUD showSuccessWithStatus:@"复制成功" toView:self.view];
    }
}

//倒计时
-(void)countDown:(NSString *)timeStr{
    NSArray *timeArr = [timeStr componentsSeparatedByString:@":"];
    __block int timeout = 0; //倒计时时间
    timeout = [timeArr[0] intValue] * 60 +  [timeArr[1] intValue] ;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout == 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时结束，刷新数据，改变订单状态
                [self.orderRightBtn setTitle:@"付款" forState:UIControlStateNormal];
                self.countDownLabel.text = @"";
                self.cancelOrderBlock();
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.orderRightBtn  setTitle:[NSString stringWithFormat:@"付款 %@",[self getMMSSFromSS:timeout]] forState:UIControlStateNormal];
                self.countDownLabel.text = [NSString stringWithFormat:@"还有 %@ 交易关闭",[self getMMSSFromSS:timeout]];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",totalTime/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",totalTime%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
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

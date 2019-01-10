//
//  LogisticsDescViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/1/8.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "LogisticsDescViewController.h"

@interface LogisticsDescViewController ()
{
    UIScrollView *_scView;
    CGFloat _currentHeight;
    NSDictionary *_logisticsDataDic;
}
@end

@implementation LogisticsDescViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"logisticsId"] = self.logisticsId;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/myOrder/logisticsInfoDtl",[PDAPI getBaseUrlString]]
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
        _logisticsDataDic = operation.jsonResult.attr;
        [self layoutUI];
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"物流详情"];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)layoutUI{
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_scView];
    _scView.backgroundColor = [UIColor whiteColor];
    _scView.bounces = NO;
    _scView.pagingEnabled = NO;
    _scView.showsVerticalScrollIndicator = NO;
    
    [self headerViewUI];
    [self logisticsViewUI];
    _scView.contentSize = CGSizeMake(0, _currentHeight);
}

#pragma mark---头部商品列表布局
-(void)headerViewUI{
    NSArray *goodsListArr = [_logisticsDataDic objectForKey:@"goodsList"];
    if (goodsListArr.count == 0) {
        return;
    }
    
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:14];
    UIFont *font_2 = [UIFont systemFontOfSize:13];
    
    for (int i = 0; i < goodsListArr.count; i++) {
        NSDictionary *dic = goodsListArr[i];

        UIImageView *productImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 80 * i + 15, 70, 70)];
        [_scView addSubview:productImgView];
        productImgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [productImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"goodsUrl"]]];
        
         UILabel *productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(productImgView.frame) + 10, CGRectGetMinY(productImgView.frame) + 5, 200, 20)];
        [_scView addSubview:productNameLabel];
        productNameLabel.font = font_1;
        productNameLabel.textColor = color_1;
        productNameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsName"]];
        
        UILabel *productDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(productImgView.frame) + 10, CGRectGetMaxY(productNameLabel.frame) + 5, 200, 20)];
        [_scView addSubview:productDescLabel];
        productDescLabel.font = font_2;
        productDescLabel.textColor = color_2;
        productDescLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"skuDesc"]];
        
        UILabel *productPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMinY(productImgView.frame) + 5, 150, 20)];
        [_scView addSubview:productPriceLabel];
        productPriceLabel.textAlignment = NSTextAlignmentRight;
        productPriceLabel.font = font_1;
        productPriceLabel.textColor = color_2;
        productPriceLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
        
         UILabel *productNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMaxY(productPriceLabel.frame) + 5, 150, 20)];
        [_scView addSubview:productNumLabel];
        productNumLabel.textAlignment = NSTextAlignmentRight;
        productNumLabel.font = font_2;
        productNumLabel.textColor = color_2;
        productNumLabel.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"num"]];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(productImgView.frame) + 15, SCREEN_WIDTH, 0.5)];
        [_scView addSubview:lineView];
        lineView.backgroundColor = [ResourceManager color_5];
        _currentHeight = CGRectGetMaxY(lineView.frame);
    }
    
    UILabel *logisticsTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _currentHeight + 15, 150, 25)];
    [_scView addSubview:logisticsTypeLabel];
    logisticsTypeLabel.font = font_2;
    logisticsTypeLabel.textColor = color_1;
    NSString *logisticsStr = [NSString stringWithFormat:@"物流状态：%@",[_logisticsDataDic objectForKey:@"logisticsLabel"]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                          initWithString:logisticsStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color_1 range:NSMakeRange(0, 5)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor] range:NSMakeRange(5, logisticsStr.length - 5)];
    logisticsTypeLabel.attributedText = attrStr;
    
    
    UILabel *expressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(logisticsTypeLabel.frame), 150, 25)];
    [_scView addSubview:expressLabel];
    expressLabel.font = font_2;
    expressLabel.textColor = color_1;
    expressLabel.text = [NSString stringWithFormat:@"%@快递包裹",[_logisticsDataDic objectForKey:@"expressCompany"]];
    
    UILabel *expressNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(expressLabel.frame) + 5, 150, 20)];
    [_scView addSubview:expressNumLabel];
    expressNumLabel.font = font_2;
    expressNumLabel.textColor = color_1;
    expressNumLabel.text = [NSString stringWithFormat:@"%@",[_logisticsDataDic objectForKey:@"expressNo"]];
    [expressNumLabel sizeToFit];
    
    UIButton *copyExpressBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(expressNumLabel.frame) + 20, CGRectGetMidY(expressNumLabel.frame) - 25/2, 70, 25)];
    [_scView addSubview:copyExpressBtn];
    copyExpressBtn.layer.borderWidth = 0.5;
    copyExpressBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    copyExpressBtn.titleLabel.font = font_1;
    [copyExpressBtn setTitle:@"复制" forState:UIControlStateNormal];
    [copyExpressBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
    [copyExpressBtn addTarget:self action:@selector(copyExpress) forControlEvents:UIControlEventTouchUpInside];
  
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(expressNumLabel.frame) + 15, SCREEN_WIDTH, 10)];
    [_scView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    _currentHeight = CGRectGetMaxY(lineView.frame);
    
}

#pragma mark---物流信息布局
-(void)logisticsViewUI{
    
    
}

-(void)copyExpress{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@",[_logisticsDataDic objectForKey:@"expressNo"]];;
    if (pasteboard.string) {
        [MBProgressHUD showSuccessWithStatus:@"复制成功" toView:self.view];
    }
}


@end

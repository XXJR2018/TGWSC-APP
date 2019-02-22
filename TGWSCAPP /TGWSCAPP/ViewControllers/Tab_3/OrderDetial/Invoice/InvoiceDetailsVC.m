//
//  InvoiceDetailsVC.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/21.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "InvoiceDetailsVC.h"

#import "InvoiceInfoVC.h"

@interface InvoiceDetailsVC ()
{
    NSDictionary *_invoiceDic;
    CGFloat _currentHeight;
}
@end

@implementation InvoiceDetailsVC

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"invoiceId"] = self.invoiceId;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/orderInvoice/dtlInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1000;
}

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (operation.jsonResult.attr.count > 0) {
        _invoiceDic = operation.jsonResult.attr;
        [self layoutUI];
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发票详情"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发票详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"发票详情"];
    [self layoutUI];
}

-(void)layoutUI{
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager mainColor];
    UIFont *font_1 = [UIFont systemFontOfSize:14];
    UIFont *font_2 = [UIFont systemFontOfSize:12];
    
    UIView *headbgView = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 100)];
    [self.view addSubview:headbgView];
    headbgView.backgroundColor = UIColorFromRGB(0xAA8853);
    
    UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (headbgView.frame.size.height - 50)/2, 50, 50)];
    [headbgView addSubview:headImgView];
    headImgView.backgroundColor= [ResourceManager viewBackgroundColor];
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = 50/2;
    [headImgView sd_setImageWithURL:[NSURL URLWithString:[[CommonInfo userInfo] objectForKey:@"headImgUrl"]]];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImgView.frame) + 10, CGRectGetMidY(headImgView.frame) - 10, 200, 20)];
    [headbgView addSubview:nameLabel];
    nameLabel.font = font_1;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = [NSString stringWithFormat:@"%@",[[CommonInfo userInfo] objectForKey:@"nickName"]];
    
    UIView *kpztView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headbgView.frame), SCREEN_WIDTH, 90)];
    [self.view addSubview:kpztView];
    kpztView.backgroundColor = [UIColor whiteColor];
    
    UILabel *kpztLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (kpztView.frame.size.height - 20)/2, 200, 20)];
    [kpztView addSubview:kpztLabel];
    kpztLabel.font = font_1;
    kpztLabel.textColor = color_1;
    if ([[_invoiceDic objectForKey:@"invoiceStatus"] intValue] == 0) {
        kpztLabel.text = @"开票状态：开票中";
        
        UIButton *changeInvoiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110, CGRectGetMidY(kpztLabel.frame) - 15, 100, 30)];
        [kpztView addSubview:changeInvoiceBtn];
        changeInvoiceBtn.titleLabel.font = font_2;
        [changeInvoiceBtn setTitle:@"修改信息" forState:UIControlStateNormal];
        [changeInvoiceBtn setTitleColor:color_2 forState:UIControlStateNormal];
        [changeInvoiceBtn setImage:[UIImage imageNamed:@"Inv_bj"] forState:UIControlStateNormal];
        [changeInvoiceBtn addTarget:self action:@selector(changeInvoice) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([[_invoiceDic objectForKey:@"invoiceStatus"] intValue] == 2) {
        kpztLabel.text = @"开票状态：开票成功";
    }
    
    _currentHeight = CGRectGetMaxY(kpztView.frame) + 10;
    
    UIView *invoiceInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, _currentHeight, SCREEN_WIDTH, 200)];
    [self.view addSubview:invoiceInfoView];
    invoiceInfoView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *orderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 13.5, 17.5)];
    [invoiceInfoView addSubview:orderImgView];
    orderImgView.image = [UIImage imageNamed:@"Inv_dd"];
    
}

//修改发票信息
-(void)changeInvoice{
    InvoiceInfoVC *ctl = [[InvoiceInfoVC alloc]init];
    ctl.invoiceId = [NSString stringWithFormat:@"%@",[_invoiceDic objectForKey:@"invoiceId"]];
    [self.navigationController pushViewController:ctl animated:YES];
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

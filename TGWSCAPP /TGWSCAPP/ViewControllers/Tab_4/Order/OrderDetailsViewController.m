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
    [_scView addSubview:headerView];
    
    
}

#pragma mark---中间控件布局
-(void)centreViewUI{
    
    
}

#pragma mark---底部控件布局
-(void)footerViewUI{
    
    
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

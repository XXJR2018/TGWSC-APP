//
//  CouponViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/26.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CouponViewController.h"

#import "CouponViewCell.h"
#import "ShopCouponViewCell.h"

@interface CouponViewController ()
{
    
    UIButton *_yhjBtn;
    UIButton *_gwjBtn;
    UIView *_lineViewX;
    UIButton *_wsyListBtn;
    UIButton *_ysyListBtn;
    UIButton *_ygqListBtn;

}
@end

@implementation CouponViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_wsyListBtn.selected) {
        params[@"status"] = @"1";
    }else if (_ysyListBtn.selected) {
        params[@"status"] = @"2";
    }else{
        params[@"status"] = @"3";
    }
    if (_yhjBtn.selected) {
        params[@"preferentialType"] = @"1";
    }else{
        params[@"preferentialType"] = @"2";
    }
    params[kPage] = @(self.pageIndex);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/activity/custPromocardListNew",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    
    if (operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        self.pageIndex --;
        if (self.pageIndex > 1) {
            [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
        }
        
        if (self.pageIndex <= 1)
         {
            [self reloadTableViewWithArray:operation.jsonResult.rows];
         }
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"优惠券"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"优惠券"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"优惠券"];
    
    _tableView.backgroundColor = [ResourceManager viewBackgroundColor];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView registerNib:[UINib nibWithNibName:@"CouponViewCell" bundle:nil] forCellReuseIdentifier:@"Coupon_Cell"];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    
    [self layoutUI];
}

-(void)layoutUI{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavHeight + 50)];
    [self.view addSubview:headerView];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _yhjBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 85, NavHeight - 40, 85, 40)];
    [headerView addSubview:_yhjBtn];
    _yhjBtn.tag = 100;
    [_yhjBtn setTitle:@"优惠券" forState:UIControlStateNormal];
    _yhjBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_yhjBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
    [_yhjBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateSelected];
    [_yhjBtn addTarget:self action:@selector(couponSort:) forControlEvents:UIControlEventTouchUpInside];
    _yhjBtn.selected = YES;
    
    _gwjBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, NavHeight - 40, 85, 40)];
    [headerView addSubview:_gwjBtn];
    _gwjBtn.tag = 101;
    [_gwjBtn setTitle:@"购物券" forState:UIControlStateNormal];
    _gwjBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_gwjBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
    [_gwjBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateSelected];
    [_gwjBtn addTarget:self action:@selector(couponSort:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView_1 = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight - 0.5, SCREEN_WIDTH, 0.5)];
    [headerView addSubview:lineView_1];
    lineView_1.backgroundColor = [ResourceManager color_5];
    
    _lineViewX = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(_yhjBtn.frame) - 30, CGRectGetMaxY(_yhjBtn.frame) - 1, 60, 1)];
    [headerView addSubview:_lineViewX];
    _lineViewX.backgroundColor = [ResourceManager mainColor];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, NavHeight - 40, 50, 40)];
    [headerView addSubview:backBtn];
    [backBtn setImage:[ResourceManager arrow_return] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *explainBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, NavHeight - 40, 90, 40)];
    [headerView addSubview:explainBtn];
    [explainBtn setTitle:@"使用说明" forState:UIControlStateNormal];
    explainBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [explainBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [explainBtn addTarget:self action:@selector(explain) forControlEvents:UIControlEventTouchUpInside];
    
    _wsyListBtn = [[UIButton alloc]init];
    _ysyListBtn = [[UIButton alloc]init];
    _ygqListBtn = [[UIButton alloc]init];
    NSArray *btnArr = @[_wsyListBtn,_ysyListBtn,_ygqListBtn];
    NSArray *titleArr = @[@"未使用",@"已使用",@"已过期"];
    for (int i = 0; i < btnArr.count; i ++) {
        UIButton *btn = ((UIButton *)btnArr[i]);
        [headerView addSubview:btn];
        btn.frame = CGRectMake(SCREEN_WIDTH/3 * i, NavHeight, SCREEN_WIDTH/3, 50);
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [btn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(couponTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *lineView_2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_wsyListBtn.frame) - 0.5, SCREEN_WIDTH, 0.5)];
    [headerView addSubview:lineView_2];
    lineView_2.backgroundColor = [ResourceManager color_5];
    
    _wsyListBtn.selected = YES;
}

- (CGRect)tableViewFrame{
    return CGRectMake(0, NavHeight + 65, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 65);
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//使用说明
-(void)explain{
    NSString *url = [NSString stringWithFormat:@"%@webMall/protocol/coupon",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"使用说明"];
}

-(void)couponSort:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender == _yhjBtn) {
        _yhjBtn.selected = YES;
        _gwjBtn.selected = NO;
        _lineViewX.frame = CGRectMake(CGRectGetMidX(_yhjBtn.frame) - 30, CGRectGetMaxY(_yhjBtn.frame) - 1, 60, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"CouponViewCell" bundle:nil] forCellReuseIdentifier:@"Coupon_Cell"];
    }else{
        _yhjBtn.selected = NO;
        _gwjBtn.selected = YES;
        _lineViewX.frame = CGRectMake(CGRectGetMidX(_gwjBtn.frame) - 30, CGRectGetMaxY(_gwjBtn.frame) - 1, 60, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"ShopCouponViewCell" bundle:nil] forCellReuseIdentifier:@"ShopCoupon_Cell"];
    }
    _wsyListBtn.selected = YES;
    _ysyListBtn.selected = NO;
    _ygqListBtn.selected = NO;
    [self.dataArray removeAllObjects];
    self.pageIndex = 1;
    [self loadData];
}

-(void)couponTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender.tag == 0) {
        _wsyListBtn.selected = YES;
        _ysyListBtn.selected = NO;
        _ygqListBtn.selected = NO;
    }else if (sender.tag == 1) {
        _wsyListBtn.selected = NO;
        _ysyListBtn.selected = YES;
        _ygqListBtn.selected = NO;
    }else{
        _wsyListBtn.selected = NO;
        _ysyListBtn.selected = NO;
        _ygqListBtn.selected = YES;
    }
    [self.dataArray removeAllObjects];
    self.pageIndex = 1;
    [self loadData];
}

#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return  1;
    }else{
        return self.dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  tableView.frame.size.height - tableView.tableHeaderView.frame.size.height;
    }else{
        if (_yhjBtn.selected) {
            return 130;
        }else{
            return 150;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    if (_yhjBtn.selected) {
        CouponViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Coupon_Cell"];
        if (!cell) {
            cell = [[CouponViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Coupon_Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.employBlock = ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@"1"}];
        };
        cell.dataDicionary = self.dataArray[indexPath.row];
        return cell;
    }else{
        ShopCouponViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCoupon_Cell"];
        if (!cell) {
            cell = [[ShopCouponViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopCoupon_Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.shareBlock = ^{
            
        };
        
        cell.dataDicionary = self.dataArray[indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}



@end

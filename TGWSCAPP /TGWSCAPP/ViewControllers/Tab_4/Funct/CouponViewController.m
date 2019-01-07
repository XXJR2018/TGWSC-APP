//
//  CouponViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/26.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CouponViewController.h"

#import "CouponViewCell.h"

@interface CouponViewController ()
{
    UIButton *_wsyListBtn;
    UIButton *_ysxListBtn;
}
@end

@implementation CouponViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_wsyListBtn.selected) {
        params[@"status"] = @"1";
    }else{
        params[@"status"] = @"2";
    }
    params[kPage] = @(self.pageIndex);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/activity/custPromocardList",[PDAPI getBaseUrlString]]
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
    UIView *headerView = [[UIView alloc]init];
    [_tableView setTableHeaderView:headerView];
  
    _wsyListBtn = [[UIButton alloc]init];
    _ysxListBtn = [[UIButton alloc]init];
    NSArray *btnArr = @[_wsyListBtn,_ysxListBtn];
    NSArray *titleArr = @[@"未使用",@"已使用"];
    for (int i = 0; i < btnArr.count; i ++) {
        UIButton *btn = ((UIButton *)btnArr[i]);
        [headerView addSubview:btn];
        btn.frame = CGRectMake(SCREEN_WIDTH/2 * i, 0, SCREEN_WIDTH/2, 50);
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [btn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(couponTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(_wsyListBtn.frame), SCREEN_WIDTH, 0.5)];
    [headerView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    _wsyListBtn.selected = YES;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(lineView.frame));
}

-(void)couponTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender.tag == 0) {
        _wsyListBtn.selected = YES;
        _ysxListBtn.selected = NO;
    }else{
        _wsyListBtn.selected = NO;
        _ysxListBtn.selected = YES;
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
        return 130;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}



@end

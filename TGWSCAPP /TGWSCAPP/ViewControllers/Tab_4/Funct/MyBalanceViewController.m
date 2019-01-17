//
//  MyBalanceViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "MyBalanceViewController.h"

#import "BalanceViewCell.h"

#import "OrderDetailsViewController.h"

@interface MyBalanceViewController ()
{
    UIView *_headerView;
    UIButton *_xfListBtn;
    UIButton *_lqListBtn;
    UIButton *_gqListBtn;
    UIButton *_makeBtn;
    UILabel *_balanceLabel;
    UILabel *_zsfyeLabel;
    UILabel *_zsfyeNumLabel;
    UIView *_lqjlView;
    UIView *_gqjlView;
}
@end

@implementation MyBalanceViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_xfListBtn.selected) {
        params[@"fundFlag"] = @"2";
    }else if (_lqListBtn.selected){
        params[@"fundFlag"] = @"1";
    }else{
        params[@"fundFlag"] = @"3";
    }
    params[kPage] = @(self.pageIndex);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/fund/fundList",[PDAPI getBaseUrlString]]
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
    if (operation.jsonResult.attr.count > 0) {
        NSDictionary *dic = operation.jsonResult.attr;
        if (_xfListBtn.selected) {
            _zsfyeLabel.text = @"总消费余额";
            _zsfyeNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"totalExpend"]];
        }else if (_lqListBtn.selected) {
            _zsfyeLabel.text = @"总领取余额";
            _zsfyeNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"totalIncome"]];
        }else{
            _zsfyeLabel.text = @"总过期余额";
            _zsfyeNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"totalOverdue"]];
        }
    }
    if (operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        self.pageIndex --;
        if (self.pageIndex > 1) {
            [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
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
    [MobClick beginLogPageView:@"我的余额"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的余额"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"我的余额"];
   
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView registerNib:[UINib nibWithNibName:@"BalanceViewCell" bundle:nil] forCellReuseIdentifier:@"Balance_Cell"];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[ResourceManager color_5]];
    
    [self layoutUI];
}

-(void)layoutUI{
    _headerView = [[UIView alloc]init];
    [_tableView setTableHeaderView:_headerView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 20)];
    [_headerView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [ResourceManager color_1];
    titleLabel.text = @"可用余额";
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), 100, 25)];
    [_headerView addSubview:_balanceLabel];
    _balanceLabel.font = [UIFont systemFontOfSize:20];
    _balanceLabel.textColor = UIColorFromRGB(0xB00000);
    _balanceLabel.text = [NSString stringWithFormat:@"￥%@",[[CommonInfo userInfo] objectForKey:@"usableAmount"]];
    
    if ([[[CommonInfo userInfo] objectForKey:@"usableAmount"] floatValue] > 0) {
        _makeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH  - 95, CGRectGetMidY(_balanceLabel.frame) - 35/2, 80, 35)];
        [_headerView addSubview:_makeBtn];
        _makeBtn.layer.borderWidth = 0.5;
        _makeBtn.layer.borderColor = UIColorFromRGB(0xB00000).CGColor;
        [_makeBtn setTitle:@"去使用" forState:UIControlStateNormal];
        _makeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_makeBtn setTitleColor:UIColorFromRGB(0xB00000) forState:UIControlStateNormal];
        [_makeBtn addTarget:self action:@selector(makeTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _xfListBtn = [[UIButton alloc]init];
    _lqListBtn = [[UIButton alloc]init];
    _gqListBtn = [[UIButton alloc]init];
    _xfListBtn.selected = YES;
    NSArray *btnArr = @[_xfListBtn,_lqListBtn,_gqListBtn];
    NSArray *titleArr = @[@"消费明细",@"领取记录",@"过期记录"];
    for (int i = 0; i < btnArr.count; i ++) {
        UIButton *btn = ((UIButton *)btnArr[i]);
        [_headerView addSubview:btn];
        btn.frame = CGRectMake(SCREEN_WIDTH/3 * i, CGRectGetMaxY(_balanceLabel.frame) + 20, SCREEN_WIDTH/3, 50);
        btn.backgroundColor = [ResourceManager viewBackgroundColor];
        btn.tag = i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        [btn setTitleColor:[ResourceManager color_1] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(banlanceTouch:) forControlEvents:UIControlEventTouchUpInside];
        if (i > 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 * i, CGRectGetMaxY(_balanceLabel.frame) + 35, 0.5, 20)];
            [_headerView addSubview:lineView];
            lineView.backgroundColor = [ResourceManager color_5];
        }
    }
    
    _zsfyeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_xfListBtn.frame), 200, 50)];
    [_headerView addSubview:_zsfyeLabel];
    _zsfyeLabel.font = [UIFont systemFontOfSize:14];
    _zsfyeLabel.textColor = [ResourceManager color_6];
    _zsfyeLabel.text = @"总消费余额";
    
    _zsfyeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMaxY(_xfListBtn.frame), 150, 50)];
    [_headerView addSubview:_zsfyeNumLabel];
    _zsfyeNumLabel.textAlignment = NSTextAlignmentRight;
    _zsfyeNumLabel.font = [UIFont systemFontOfSize:14];
    _zsfyeNumLabel.textColor = [ResourceManager mainColor];
    _zsfyeNumLabel.text = @"0";
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_zsfyeNumLabel.frame), SCREEN_WIDTH - 20, 0.5)];
    [_headerView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_zsfyeLabel.frame));
}

-(void)makeTouch{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@"1"}];
}


-(void)banlanceTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    [_lqjlView removeFromSuperview];
    if (sender.tag == 0) {
        _xfListBtn.selected = YES;
        _lqListBtn.selected = NO;
        _gqListBtn.selected = NO;
         _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_zsfyeLabel.frame));
    }else if (sender.tag == 1) {
        _xfListBtn.selected = NO;
        _lqListBtn.selected = YES;
        _gqListBtn.selected = NO;
        _lqjlView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_zsfyeLabel.frame), SCREEN_WIDTH, 40)];
        [_headerView addSubview:_lqjlView];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_lqjlView.frame));
        NSArray *titleArr = @[@"领取时间",@"到期时间",@"到账余额（元)"];
        for (int i = 0;  i < titleArr.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 + (SCREEN_WIDTH - 20)/3 * i, 0, (SCREEN_WIDTH - 20)/3, 40)];
            [_lqjlView addSubview:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [ResourceManager color_1];
            label.text = titleArr[i];
            if (i == 0) {
                label.textAlignment = NSTextAlignmentLeft;
            }else if (i == 1) {
                label.textAlignment = NSTextAlignmentCenter;
            }else{
                label.textAlignment = NSTextAlignmentRight;
            }
        }
    }else{
        _xfListBtn.selected = NO;
        _lqListBtn.selected = NO;
        _gqListBtn.selected = YES;
        _lqjlView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_zsfyeLabel.frame), SCREEN_WIDTH, 40)];
        [_headerView addSubview:_lqjlView];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_lqjlView.frame));
        NSArray *titleArr = @[@"过期时间",@"过期余额（元)"];
        for (int i = 0;  i < titleArr.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 +(SCREEN_WIDTH - 20)/2 * i, 0, (SCREEN_WIDTH - 20)/2, 40)];
            [_lqjlView addSubview:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [ResourceManager color_1];
            label.text = titleArr[i];
            if (i == 0) {
                label.textAlignment = NSTextAlignmentLeft;
            }else{
                label.textAlignment = NSTextAlignmentRight;
            }
        }
    }
    [self.dataArray removeAllObjects];
    self.pageIndex = 1;
    [self loadData];
    [_tableView reloadData];
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
        if (_xfListBtn.selected) {
            return 100;
        }else{
            return 50;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    if (_xfListBtn.selected) {
        BalanceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Balance_Cell"];
        if (!cell) {
            cell = [[BalanceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Balance_Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dataDicionary = self.dataArray[indexPath.row];
        return cell;
    }else if (_lqListBtn.selected) {
        NSString *cellID = [NSString stringWithFormat:@"%ld_lqcell",indexPath.row];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSArray *titleArr = @[[dic objectForKey:@"ymdCreateTime"],[dic objectForKey:@"validEndDate"],[dic objectForKey:@"amount"]];
        for (int i = 0;  i < titleArr.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 + (SCREEN_WIDTH - 20)/3 * i, 0, (SCREEN_WIDTH - 20)/3, 40)];
            [cell.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [ResourceManager color_1];
            label.text = [NSString stringWithFormat:@"%@",titleArr[i]];
            if (i == 0) {
                label.textAlignment = NSTextAlignmentLeft;
            }else if (i == 1) {
                label.textAlignment = NSTextAlignmentCenter;
            }else{
                label.textAlignment = NSTextAlignmentRight;
            }
        }
        return cell;
    }else {
        NSString *cellID = [NSString stringWithFormat:@"%ld_gqcell",indexPath.row];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSArray *titleArr = @[[dic objectForKey:@"createTime"],[dic objectForKey:@"amount"]];
        for (int i = 0;  i < titleArr.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 + (SCREEN_WIDTH - 20)/2 * i, 0, (SCREEN_WIDTH - 20)/2, 40)];
            [cell.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [ResourceManager color_1];
            label.text = [NSString stringWithFormat:@"%@",titleArr[i]];
            if (i == 0) {
                label.textAlignment = NSTextAlignmentLeft;
            }else{
                label.textAlignment = NSTextAlignmentRight;
            }
        }
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (_xfListBtn.selected) {
        OrderDetailsViewController *ctl = [[OrderDetailsViewController alloc]init];
        ctl.orderNo = [NSString stringWithFormat:@"%@",[(NSDictionary *)self.dataArray[indexPath.row] objectForKey:@"orderNo"]];
        [self.navigationController pushViewController:ctl animated:YES];
    }

}



@end

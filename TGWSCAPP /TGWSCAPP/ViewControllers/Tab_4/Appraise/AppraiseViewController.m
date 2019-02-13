//
//  AppraiseViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/13.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseViewController.h"

#import "AppraiseViewCell.h"
@interface AppraiseViewController ()
{
    UIView *_headerView;
    UIButton *_dpjBtn;
    UIButton *_wdpjBtn;
}
@end

@implementation AppraiseViewController

-(void)loadData123{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kPage] = @(self.pageIndex);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/myOrder/allList",[PDAPI getBaseUrlString]]
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
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    
    if (operation.tag == 1000) {
        if (operation.jsonResult.rows.count > 0) {
            [self reloadTableViewWithArray:operation.jsonResult.rows];
        }else{
            if (self.pageIndex > 1) {
                self.pageIndex --;
                [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
            }
        }
    }
    
}
         
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"评价"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"评价"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"评价"];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView registerClass:[AppraiseViewCell class] forCellReuseIdentifier:@"Appraise_cell"];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    
    [self layoutUI];
}

-(void)layoutUI{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableHeaderView:_headerView];
    
    _dpjBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [_headerView addSubview:_dpjBtn];
    _dpjBtn.tag = 100;
    _dpjBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_dpjBtn setTitle:@"待评价" forState:UIControlStateNormal];
    [_dpjBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [_dpjBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
    [_dpjBtn addTarget:self action:@selector(appraise:) forControlEvents:UIControlEventTouchUpInside];
    _dpjBtn.selected = YES;
    
    _wdpjBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    [_headerView addSubview:_wdpjBtn];
    _wdpjBtn.tag = 101;
    _wdpjBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_wdpjBtn setTitle:@"我的评价" forState:UIControlStateNormal];
    [_wdpjBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [_wdpjBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
    [_wdpjBtn addTarget:self action:@selector(appraise:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50 - 0.5, SCREEN_WIDTH, 0.5)];
    [_headerView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
}

-(void)appraise:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender.tag == 100) {
        _dpjBtn.selected = YES;
        _wdpjBtn.selected = NO;
    }else{
        _dpjBtn.selected = NO;
        _wdpjBtn.selected = YES;
    }
}

#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return tableView.frame.size.height;
    }else{
//        NSDictionary *dic = self.dataArray[indexPath.row];
//        NSArray *orderDtlListArr = [dic objectForKey:@"orderDtlList"];
//        if ([[dic objectForKey:@"freightAmt"] intValue] > 0) {
//            return orderCellHeight * orderDtlListArr.count + 155;
//        }
//        return orderCellHeight * orderDtlListArr.count + 135;
        return 200;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    NSString *cellID = [NSString stringWithFormat:@"%ld_Appraise_cell",indexPath.row];
    AppraiseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AppraiseViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
//    cell.dataDicionary = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (self.dataArray.count == 0) {
        return;
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

//
//  OrderListViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "OrderListViewController.h"

#import "OrderListViewCell.h"


#define orderCellHeight  100

@interface OrderListViewController ()

@end

@implementation OrderListViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.orderStatus.length > 0) {
        params[@"orderStatus"] = self.orderStatus;
    }
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
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[OrderListViewCell class] forCellReuseIdentifier:@"OrderList_Cell"];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
}

- (CGRect)tableViewFrame{
    return CGRectMake(0, 0, SCREEN_WIDTH, self.view.size.height);
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
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSArray *orderDtlListArr = [dic objectForKey:@"orderDtlList"];
        if ([[dic objectForKey:@"freightAmt"] intValue] > 0) {
            return orderCellHeight * orderDtlListArr.count + 155;
        }
        return orderCellHeight * orderDtlListArr.count + 135;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    OrderListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderList_Cell"];
    if (!cell) {
        cell = [[OrderListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderList_Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.orderLeftBlock = ^{
        [self orderLeftTouch:self.dataArray[indexPath.row]];
    };
    cell.orderRightBlock = ^{
        [self orderRightTouch:self.dataArray[indexPath.row]];
    };
    cell.dataDicionary = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *goodsCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsCode"]];
    if (goodsCode.length > 0) {
        
    }
    
}

#pragma mark--订单列表按钮点击事件
-(void)orderLeftTouch:(NSDictionary *)dic{
    //    状态（//0-待付款 1-交易成功 2-交易失败 3-卖家确认(待发货) 4-卖家审核失败 5-已发货  6-确认收货 7-交易关闭  8-退款成功  ）
    NSInteger status = [[dic objectForKey:@"status"] intValue];
    NSLog(@"status == %ld",status);
    
}

-(void)orderRightTouch:(NSDictionary *)dic{
    //    状态（//0-待付款 1-交易成功 2-交易失败 3-卖家确认(待发货) 4-卖家审核失败 5-已发货  6-确认收货 7-交易关闭  8-退款成功  ）
    NSInteger status = [[dic objectForKey:@"status"] intValue];
    NSLog(@"status == %ld",status);
    
}

@end

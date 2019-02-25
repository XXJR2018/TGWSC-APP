//
//  AllAppraiseListViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/25.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AllAppraiseListViewController.h"
#import "AllAppraiseListCell.h"
#import "AllAppraiseView.h"
@interface AllAppraiseListViewController ()
{
    UIView *_aleartView;
    NSInteger _lableId;
    UIView *_headerView;
}
@end

@implementation AllAppraiseListViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kPage] = @(self.pageIndex);
    params[@"goodsCode"] = self.goodsCode;
    params[@"lableId"] = @(_lableId);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/orderComment/queryAllCommList",[PDAPI getBaseUrlString]]
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

-(void)GoodsLableUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"goodsCode"] = self.goodsCode;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/orderComment/queryGoodsLable",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1001;
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
    }else if (operation.tag == 1001) {
        if (operation.jsonResult.attr.count > 0 && operation.jsonResult.rows.count > 0) {
            [self headerViewUI:operation.jsonResult.attr lableList:operation.jsonResult.rows];
            [_tableView reloadData];
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
    [MobClick beginLogPageView:@"全部评价"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"全部评价"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"全部评价"];
    
    [self layoutUI];
    self.goodsCode = @"10201008";
    [self GoodsLableUrl];
}

-(void)layoutUI{
    
    [_tableView registerClass:[AllAppraiseListCell class] forCellReuseIdentifier:@"AllAppraiseList_cell"];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[ResourceManager color_5]];
}

-(void)headerViewUI:(NSDictionary *)dic lableList:(NSArray *)lableListArr{
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableHeaderView:_headerView];
    
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
        //根据数据计算当前cell高度
        AllAppraiseView *view = [[AllAppraiseView alloc]initWithAppraiseListViewLayoutUI:self.dataArray[indexPath.row]];
        return view.frame.size.height;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    NSString *cellID = [NSString stringWithFormat:@"%ld_AllAppraiseList_cell",indexPath.row];
    AllAppraiseListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AllAppraiseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.dataDicionary = dic;
    cell.clickEnlargeBlock = ^(int touchTag){
        NSString *imgUrl;
        if (touchTag < 100) {
            //3.分隔字符串
            NSString *imgUrls =[NSString stringWithFormat:@"%@",[dic objectForKey:@"imgUrl"]];
            NSArray *imgArr = [imgUrls componentsSeparatedByString:@","]; //从字符A中分隔成多个元素的数组
            imgUrl = imgArr[touchTag];
        }else{
            //3.分隔字符串
            NSString *imgUrls =[NSString stringWithFormat:@"%@",[dic objectForKey:@"appendImgUrl"]];
            NSArray *imgArr = [imgUrls componentsSeparatedByString:@","]; //从字符A中分隔成多个元素的数组
            imgUrl = imgArr[touchTag - 100];
        }
        //点击图片放大
        [self clickEnlargeImg:imgUrl];
    };
    
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

#pragma mark---点击图片放大
-(void)clickEnlargeImg:(NSString *)imgUrl{
    [_aleartView  removeFromSuperview];
    
    _aleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_aleartView];
    _aleartView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH)];
    [_aleartView addSubview:imgview];
    [imgview sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenAlert)];
    tapGeture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:tapGeture];
    
}

//点击背景消失弹窗
-(void)hidenAlert{
    [_aleartView removeFromSuperview];
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

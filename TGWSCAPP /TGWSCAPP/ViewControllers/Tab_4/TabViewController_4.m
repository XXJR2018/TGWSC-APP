//
//  TabViewController_4.m
//  XXJR
//
//  Created by xxjr03 on 2018/12/4.
//  Copyright © 2018 Cary. All rights reserved.
//

#import "TabViewController_4.h"

#import "UserInfoViewController.h"
#import "OrderViewController.h"
#import "MyBalanceViewController.h"
#import "MyScoresViewController.h"
#import "CouponViewController.h"
#import "MyCollectViewController.h"
#import "AddressViewController.h"
#import "CustomerServiceViewController.h"
#import "RefundListVC.h"

#import "JXButton.h"


@interface TabViewController_4 ()
{
    UIImageView *_headImgView;
    UILabel *_phoneLabel;
    
    UIImageView *_orderImgView;
    UILabel *_dfkNumLabel;
    UILabel *_dfhNumLabel;
    UILabel *_yfhNumLabel;
    UILabel *_tkNumLabel;
    
    UILabel *_balanceNumLabel;  //余额
    UILabel *_pointsNumLabel;   // 积分
    UILabel *_couponNumLabel;   // 优惠券
    UILabel *_collectNumLabel;   // 收藏
    UIButton *_couponBtn;   //优惠券按钮
    
    UIView *_logisticsView;   //物流信息布局
}

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIView *headView;

@property(nonatomic, strong)UIView *footView;
@end

@implementation TabViewController_4

-(void)custSummaryUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/info/custSummary",[PDAPI getBaseUrlString]]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
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
    if (operation.jsonResult.attr.count > 0) {
        [self changeOrderInfo:operation.jsonResult.attr];
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    [_tableView.mj_header endRefreshing];
}

#pragma mark-- 刷新用户数据更新用户信息显示
-(void)changeUserInfo{
    if ([CommonInfo userInfo].count == 0) {
        return;
    }
    NSDictionary *dic = [CommonInfo userInfo];
    //头像
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"headImgUrl"]].length > 0) {
        [_headImgView sd_setImageWithURL:[dic objectForKey:@"headImgUrl"] placeholderImage:[UIImage imageNamed:@"Tab_4-2"]];
    }else{
        _headImgView.image = [UIImage imageNamed:@"Tab_4-2"];
    }
    //昵称/电话
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]].length > 0) {
        _phoneLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]];
    }else{
        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"hideTelephone"]].length > 0) {
            _phoneLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hideTelephone"]];
        }else{
            _phoneLabel.text = @"请登录";
        }
    }
    
}

#pragma mark-- 刷新订单信息
-(void)changeOrderInfo:(NSDictionary *)dic{
    //代付款
    if ([[dic objectForKey:@"noPayOrderCount"] intValue] > 0) {
        _dfkNumLabel.hidden = NO;
        _dfkNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noPayOrderCount"]];
    }else{
        _dfkNumLabel.hidden = YES;
        _dfkNumLabel.text = @"";
    }
    //代发货
    if ([[dic objectForKey:@"noSendOrderCount"] intValue] > 0) {
        _dfhNumLabel.hidden = NO;
        _dfhNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noSendOrderCount"]];
    }else{
        _dfhNumLabel.hidden = YES;
        _dfhNumLabel.text = @"";
    }
    //已发货
    if ([[dic objectForKey:@"sendOrderCount"] intValue] > 0) {
        _yfhNumLabel.hidden = NO;
        _yfhNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sendOrderCount"]];
    }else{
        _yfhNumLabel.hidden = YES;
        _yfhNumLabel.text = @"";
    }
//    //退款/售后
//    if ([[dic objectForKey:@"noPayOrderCount"] intValue] > 0) {
//        _tkNumLabel.hidden = NO;
//        _tkNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noPayOrderCount"]];
//    }else{
//        _tkNumLabel.hidden = YES;
//        _tkNumLabel.text = @"";
//    }
    
    //余额
    if ([[dic objectForKey:@"usableAmount"] floatValue] > 0) {
        _balanceNumLabel.text  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usableAmount"]];
    }else{
        _balanceNumLabel.text = @"";
    }
    //积分
    if ([[dic objectForKey:@"totalScore"] intValue] > 0) {
        _pointsNumLabel.text  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"totalScore"]];
    }else{
        _pointsNumLabel.text = @"";
    }
    //优惠券按钮
    if ([[dic objectForKey:@"validCardCount"] intValue] > 0) {
        _couponNumLabel.text  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"validCardCount"]];
        [_couponBtn setImage:[UIImage imageNamed:@"Tab_4-18"] forState:UIControlStateNormal];
    }else{
        _couponNumLabel.text = @"";
        [_couponBtn setImage:[UIImage imageNamed:@"Tab_4-14"] forState:UIControlStateNormal];
    }
    //收藏
    if ([[dic objectForKey:@"favoriteCount"] intValue] > 0) {
        _collectNumLabel.text  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"favoriteCount"]];
    }else{
        _collectNumLabel.text = @"";
    }
   
    NSArray *sticsListArr = [dic objectForKey:@"logisticsList"];
    if (sticsListArr.count == 0) {
        _logisticsView.frame = CGRectMake(0, CGRectGetMaxY(_orderImgView.frame), SCREEN_WIDTH, 0);
        self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_logisticsView.frame));
    }else{
         _logisticsView.frame = CGRectMake(0, CGRectGetMaxY(_orderImgView.frame), SCREEN_WIDTH, 120);
        
        
        
    }
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_logisticsView.frame));
    [_tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人中心"];
    //改变商品数量
    [self custSummaryUrl];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人中心"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hideBackButton = YES;
    [self layoutNaviBarViewWithTitle:@"个人中心"];
    
    [self layoutUI];
    
    [self changeUserInfo];
    // 更新用户头像等信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo) name:@"NotificationChangeUserInfo" object:nil];
}

-(void)layoutUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight)];
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //发送通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
        [self custSummaryUrl];
        [self.tableView reloadData];
    }];

    self.headView = [UIView new];
    self.footView = [UIView new];
    [self.tableView setTableHeaderView:self.headView];
    [self.tableView setTableFooterView:self.footView];
    
    [self headViewUI];
    [self footViewUI];
}

#pragma mark--headViewUI
-(void)headViewUI{
    
    UIImageView *backdropImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 275 * ScaleSize)];
    [self.headView addSubview:backdropImgView];
    backdropImgView.image = [UIImage imageNamed:@"Tab_4-1"];
    backdropImgView.userInteractionEnabled = YES;
    
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, NavHeight - 20, 50 * ScaleSize, 50 * ScaleSize)];
    [backdropImgView addSubview:_headImgView];
    _headImgView.image = [UIImage imageNamed:@"Tab_4-2"];
    _headImgView.userInteractionEnabled = YES;
    // 没这句话倒不了角
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = 50 * ScaleSize/2;
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImgView.frame) + 15, CGRectGetMidY(_headImgView.frame) - 10, 100, 20)];
    [backdropImgView addSubview:_phoneLabel];
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    _phoneLabel.text = @"请登录";
    
    UIButton *userInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backdropImgView.frame) - 50, CGRectGetMidY(_headImgView.frame) - 15, 30, 30)];
    [backdropImgView addSubview:userInfoBtn];
    [userInfoBtn setImage:[UIImage imageNamed:@"Tab_4-3"] forState:UIControlStateNormal];
    [userInfoBtn addTarget:self action:@selector(userInfo) forControlEvents:UIControlEventTouchUpInside];
    
    _orderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImgView.frame) + 10, SCREEN_WIDTH, 168 * ScaleSize)];
    [backdropImgView addSubview:_orderImgView];
    _orderImgView.image = [UIImage imageNamed:@"Tab_4-4"];
    _orderImgView.userInteractionEnabled = YES;
    
    _logisticsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_orderImgView.frame), SCREEN_WIDTH, 0)];
    [self.headView addSubview:_logisticsView];

    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_logisticsView.frame));
    
    [self orderViewUI];
}

#pragma mark 订单按钮布局
-(void)orderViewUI{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 340 * ScaleSize)/2 + 15, 25 * ScaleSize, 150, 30)];
    [_orderImgView addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.text = @"我的订单";
    titleLabel.textColor = [ResourceManager color_1];
    
    UIButton *allOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(_orderImgView.frame.size.width - 100 - (SCREEN_WIDTH - 340 * ScaleSize)/2, 25 * ScaleSize, 100, 30)];
    [_orderImgView addSubview:allOrderBtn];
    allOrderBtn.tag = 99;
    allOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [allOrderBtn setTitle:@"全部订单 >" forState:UIControlStateNormal];
    [allOrderBtn setTitleColor:UIColorFromRGB(0x85775b) forState:UIControlStateNormal];
    [allOrderBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat btnLeft = (SCREEN_WIDTH - 310 * ScaleSize)/2;
    CGFloat btnWidth = (310 * ScaleSize)/4;
    NSArray *imgArr = @[@"Tab_4-5",@"Tab_4-6",@"Tab_4-7",@"Tab_4-8"];
    NSArray *titleArr = @[@"待付款",@"待发货",@"已发货",@"退款/售后"];
    for (int i = 0; i < 4; i ++) {
        JXButton *orderBtn = [[JXButton alloc]initWithFrame:CGRectMake(btnLeft + btnWidth * i, CGRectGetMaxY(titleLabel.frame) + 10, btnWidth, btnWidth)];
        [_orderImgView addSubview:orderBtn];
        orderBtn.tag = i + 100;
        [orderBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
        [orderBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [orderBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [orderBtn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        if (i == 0) {
            _dfkNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 33, 5, 12, 12)];
            [orderBtn addSubview:_dfkNumLabel];
            _dfkNumLabel.clipsToBounds = YES;
            _dfkNumLabel.layer.cornerRadius = 12/2;
            _dfkNumLabel.backgroundColor = [UIColor redColor];
            _dfkNumLabel.textColor = [UIColor whiteColor];
            _dfkNumLabel.textAlignment = NSTextAlignmentCenter;
            _dfkNumLabel.font = [UIFont systemFontOfSize:8];
            _dfkNumLabel.hidden = YES;
        }else if (i == 1) {
            _dfhNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 33, 5, 12, 12)];
            [orderBtn addSubview:_dfhNumLabel];
            _dfhNumLabel.clipsToBounds = YES;
            _dfhNumLabel.layer.cornerRadius = 12/2;
            _dfhNumLabel.backgroundColor = [UIColor redColor];
            _dfhNumLabel.textColor = [UIColor whiteColor];
            _dfhNumLabel.textAlignment = NSTextAlignmentCenter;
            _dfhNumLabel.font = [UIFont systemFontOfSize:8];
            _dfhNumLabel.hidden = YES;
        }else if (i == 2) {
            _yfhNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 33, 5, 12, 12)];
            [orderBtn addSubview:_yfhNumLabel];
            _yfhNumLabel.clipsToBounds = YES;
            _yfhNumLabel.layer.cornerRadius = 12/2;
            _yfhNumLabel.backgroundColor = [UIColor redColor];
            _yfhNumLabel.textColor = [UIColor whiteColor];
            _yfhNumLabel.textAlignment = NSTextAlignmentCenter;
            _yfhNumLabel.font = [UIFont systemFontOfSize:8];
            _yfhNumLabel.hidden = YES;
        }else if (i == 3) {
            _tkNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 33, 5, 12, 12)];
            [orderBtn addSubview:_tkNumLabel];
            _tkNumLabel.clipsToBounds = YES;
            _tkNumLabel.layer.cornerRadius = 12/2;
            _tkNumLabel.backgroundColor = [UIColor redColor];
            _tkNumLabel.textColor = [UIColor whiteColor];
            _tkNumLabel.textAlignment = NSTextAlignmentCenter;
            _tkNumLabel.font = [UIFont systemFontOfSize:8];
             _tkNumLabel.hidden = YES;
        }
    }
    
    
}


#pragma mark--footViewUI
-(void)footViewUI{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7)];
    [self.footView addSubview:view];
    view.backgroundColor = [ResourceManager viewBackgroundColor];
    
    CGFloat btnWidth = SCREEN_WIDTH/4;
    CGFloat currentHeight = 0;
    NSArray *imgArr = @[@"Tab_4-12",@"Tab_4-13",@"Tab_4-14",@"Tab_4-15",@"Tab_4-16",@"Tab_4-17"];
    NSArray *titleArr = @[@"我的余额",@"我的积分",@"优惠券",@"我的收藏",@"地址管理",@"客服中心"];
   
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 4; j ++) {
            NSInteger count = i * 4 + j;
            if ([[[CommonInfo userInfo] objectForKey:@"isEmployee"] intValue] == 0) {
                count = i * 4 + j + 1;
            }
            if (count < imgArr.count) {
                if (count == 2) {
                    _couponBtn = [[JXButton alloc]initWithFrame:CGRectMake(btnWidth * j, btnWidth * i + 20 * (i + 1), btnWidth, btnWidth)];
                    [self.footView addSubview:_couponBtn];
                    _couponBtn.tag = count;
                    [_couponBtn addTarget:self action:@selector(functTouch:) forControlEvents:UIControlEventTouchUpInside];
                    [_couponBtn setTitle:titleArr[count] forState:UIControlStateNormal];
                    [_couponBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
                    [_couponBtn setImage:[UIImage imageNamed:imgArr[count]] forState:UIControlStateNormal];
                    
                    _couponNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnWidth - 20, btnWidth, 15)];
                    [_couponBtn addSubview:_couponNumLabel];
                    _couponNumLabel.textAlignment = NSTextAlignmentCenter;
                    _couponNumLabel.textColor = [ResourceManager mainColor];
                    _couponNumLabel.font = [UIFont systemFontOfSize:12];
                }else{
                    JXButton *functBtn = [[JXButton alloc]initWithFrame:CGRectMake(btnWidth * j, btnWidth * i + 20 * (i + 1), btnWidth, btnWidth)];
                    [self.footView addSubview:functBtn];
                    functBtn.tag = count;
                    [functBtn addTarget:self action:@selector(functTouch:) forControlEvents:UIControlEventTouchUpInside];
                    [functBtn setTitle:titleArr[count] forState:UIControlStateNormal];
                    [functBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
                    [functBtn setImage:[UIImage imageNamed:imgArr[count]] forState:UIControlStateNormal];
                    
                    if (count == 0) {
                        _balanceNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnWidth - 20, btnWidth, 15)];
                        [functBtn addSubview:_balanceNumLabel];
                        _balanceNumLabel.textAlignment = NSTextAlignmentCenter;
                        _balanceNumLabel.textColor = [ResourceManager mainColor];
                        _balanceNumLabel.font = [UIFont systemFontOfSize:12];
                    }else if (count == 1) {
                        _pointsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnWidth - 20, btnWidth, 15)];
                        [functBtn addSubview:_pointsNumLabel];
                        _pointsNumLabel.textAlignment = NSTextAlignmentCenter;
                        _pointsNumLabel.textColor = [ResourceManager mainColor];
                        _pointsNumLabel.font = [UIFont systemFontOfSize:12];
                    }else if (count == 3) {
                        _collectNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnWidth - 20, btnWidth, 15)];
                        [functBtn addSubview:_collectNumLabel];
                        _collectNumLabel.textAlignment = NSTextAlignmentCenter;
                        _collectNumLabel.textColor = [ResourceManager mainColor];
                        _collectNumLabel.font = [UIFont systemFontOfSize:12];
                    }
                    currentHeight = CGRectGetMaxY(functBtn.frame);
                }
            }
        }
    }
    
    UIImageView *bannerImgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 338.5 * ScaleSize)/2, currentHeight + 10, 338.5 * ScaleSize, 78 * ScaleSize)];
    [_footView addSubview:bannerImgView];
    bannerImgView.image = [UIImage imageNamed:@"Tab_4-9"];
    bannerImgView.userInteractionEnabled = YES;
    
    self.footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(bannerImgView.frame) + 10);
    
}

-(void)userInfo{
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    UserInfoViewController *ctl = [[UserInfoViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark----订单按钮点击事件orderTouch
-(void)orderTouch:(UIButton *)sender{
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 99:{
            //全部订单
            OrderViewController *ctl = [[OrderViewController alloc]init];
            ctl.orderIndex = 0;
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 100:{
            //代付款
            OrderViewController *ctl = [[OrderViewController alloc]init];
            ctl.orderIndex = 1;
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 101:{
            //代发货
            OrderViewController *ctl = [[OrderViewController alloc]init];
            ctl.orderIndex = 2;
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 102:{
            //已发货
            OrderViewController *ctl = [[OrderViewController alloc]init];
            ctl.orderIndex = 3;
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 103:{
            //退款/售后
            RefundListVC *ctl = [[RefundListVC alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        default:
            break;
    }
    
}

#pragma mark----funct底部功能按钮点击事件
-(void)functTouch:(UIButton *)sender{
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 0:{
            //我的余额
            MyBalanceViewController *ctl = [[MyBalanceViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 1:{
            //我的积分
            MyScoresViewController *ctl = [[MyScoresViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 2:{
            //优惠券
            CouponViewController *ctl = [[CouponViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 3:{
            //我的收藏
            MyCollectViewController *ctl = [[MyCollectViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 4:{
            //地址管理
            AddressViewController *ctl = [[AddressViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 5:{
            //客服中心
            CustomerServiceViewController *ctl = [[CustomerServiceViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        default:
            break;
    }
    
}





-(void)addButtonView{
    [self.view addSubview:self.tabBar];
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

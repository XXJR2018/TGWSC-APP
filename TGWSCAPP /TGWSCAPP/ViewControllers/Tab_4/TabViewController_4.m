//
//  TabViewController_4.m
//  XXJR
//
//  Created by xxjr03 on 2018/12/4.
//  Copyright © 2018 Cary. All rights reserved.
//

#import "TabViewController_4.h"

#import "JXButton.h"

@interface TabViewController_4 ()
{
    UIImageView *_headImgView;
    UILabel *_phoneLabel;
    
    UIImageView *_orderImgView;
    JXButton *_dfkOrderBtn;
    JXButton *_dfhOrderBtn;
    JXButton *_yfhOrderBtn;
    JXButton *_tkOrderBtn;
    
    
}

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIView *headView;

@property(nonatomic, strong)UIView *footView;
@end

@implementation TabViewController_4

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人中心"];
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
    
}

-(void)layoutUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight)];
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
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
    
    UIImageView *backdropImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 360 * ScaleSize)];
    [self.headView addSubview:backdropImgView];
    backdropImgView.image = [UIImage imageNamed:@"Tab_4-1"];
    backdropImgView.userInteractionEnabled = YES;
    
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, NavHeight - 20, 50 * ScaleSize, 50 * ScaleSize)];
    [backdropImgView addSubview:_headImgView];
    _headImgView.image = [UIImage imageNamed:@"Tab_4-2"];
    backdropImgView.userInteractionEnabled = YES;
 
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImgView.frame) + 15, CGRectGetMidY(_headImgView.frame) - 10, 100, 20)];
    [backdropImgView addSubview:_phoneLabel];
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    _phoneLabel.text = @"请登录";
    
    UIButton *userInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backdropImgView.frame) - 40, CGRectGetMidY(_headImgView.frame) - 10, 10, 20)];
    [backdropImgView addSubview:userInfoBtn];
    [userInfoBtn setImage:[UIImage imageNamed:@"Tab_4-3"] forState:UIControlStateNormal];
    [userInfoBtn addTarget:self action:@selector(userInfo) forControlEvents:UIControlEventTouchUpInside];
    
    _orderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImgView.frame) + 10, SCREEN_WIDTH, 168 * ScaleSize)];
    [backdropImgView addSubview:_orderImgView];
    _orderImgView.image = [UIImage imageNamed:@"Tab_4-4"];
    backdropImgView.userInteractionEnabled = YES;
    
    UIImageView *bannerImgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 350 * ScaleSize)/2, CGRectGetMaxY(_orderImgView.frame), 350 * ScaleSize, 83 * ScaleSize)];
    [backdropImgView addSubview:bannerImgView];
    bannerImgView.image = [UIImage imageNamed:@"Tab_4-9"];
    bannerImgView.userInteractionEnabled = YES;

    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(backdropImgView.frame));
    
    [self orderViewUI];
}

#pragma mark 订单按钮布局
-(void)orderViewUI{
    [_orderImgView removeAllSubviews];
 
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
    }
    
    
}


#pragma mark--footViewUI
-(void)footViewUI{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7)];
    [self.footView addSubview:view];
    view.backgroundColor = [ResourceManager viewBackgroundColor];
    
    CGFloat btnWidth = SCREEN_WIDTH/4;
    NSArray *imgArr = @[@"Tab_4-10",@"Tab_4-11",@"Tab_4-10",@"Tab_4-11",@"Tab_4-10",@"Tab_4-11"];
    NSArray *titleArr = @[@"地址管理",@"客服中心",@"地址管理3",@"客服中心4",@"地址管理5",@"客服中心6"];
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 4; j ++) {
            if (i * 4 + j < imgArr.count) {
                JXButton *functBtn = [[JXButton alloc]initWithFrame:CGRectMake(btnWidth * j, btnWidth * i + 20, btnWidth, btnWidth)];
                [self.footView addSubview:functBtn];
                functBtn.tag = i * 4 + j;
                [functBtn addTarget:self action:@selector(functTouch:) forControlEvents:UIControlEventTouchUpInside];
                [functBtn setTitle:titleArr[i * 4 + j] forState:UIControlStateNormal];
                [functBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
                [functBtn setImage:[UIImage imageNamed:imgArr[i * 4 + j]] forState:UIControlStateNormal];
                
                self.footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(functBtn.frame) + 20);
            }
        }
    }
    
}




-(void)userInfo{
    
}

#pragma mark----订单按钮点击事件orderTouch
-(void)orderTouch:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 100:{
            
        }break;
        case 101:{
            
        }break;
        case 102:{
            
        }break;
        case 103:{
            
        }break;
        default:
            break;
    }
    
}

#pragma mark----funct底部功能按钮点击事件
-(void)functTouch:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 0:{
            
        }break;
        case 1:{
            
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

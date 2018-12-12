//
//  TabViewController_4.m
//  XXJR
//
//  Created by xxjr03 on 2018/12/4.
//  Copyright © 2018 Cary. All rights reserved.
//

#import "TabViewController_4.h"

@interface TabViewController_4 ()
{
    UIImageView *_headImgView;
    UILabel *_phoneLabel;
    
    UIImageView *_orderImgView;
    
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
    
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, NavHeight, 50 * ScaleSize, 50 * ScaleSize)];
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
    
    _orderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImgView.frame) + 20, SCREEN_WIDTH, 118 * ScaleSize)];
    [backdropImgView addSubview:_orderImgView];
    _orderImgView.image = [UIImage imageNamed:@"Tab_4-4"];
    backdropImgView.userInteractionEnabled = YES;
    
    UIImageView *bannerImgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 350 * ScaleSize)/2, CGRectGetMaxY(_orderImgView.frame) + 10, 350 * ScaleSize, 83 * ScaleSize)];
    [backdropImgView addSubview:bannerImgView];
    bannerImgView.image = [UIImage imageNamed:@"Tab_4-9"];
    bannerImgView.userInteractionEnabled = YES;

    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(backdropImgView.frame));
}

#pragma mark--footViewUI
-(void)footViewUI{
    
     self.footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.tableView.tableHeaderView.frame.size.height- TabbarHeight);
    self.footView.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7)];
    [self.footView addSubview:view];
    view.backgroundColor = [ResourceManager viewBackgroundColor];
}


-(void)userInfo{
    
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

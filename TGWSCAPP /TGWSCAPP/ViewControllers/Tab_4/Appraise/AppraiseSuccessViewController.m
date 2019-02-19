//
//  AppraiseSuccessViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/15.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseSuccessViewController.h"
#import "IssueAppraiseViewController.h"

#import "AppraiseSuccessCell.h"

@interface AppraiseSuccessViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_headerView;
    UITableView *_tableView;
}
@end

@implementation AppraiseSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"评论"];
    
    [self layoutUI];
    
    if (self.appraiseDataDic.count > 0) {
        if ([[self.appraiseDataDic objectForKey:@"isComment"] intValue] == 0) {
            //推荐商品列表
            NSArray *showGoodsList = [self.appraiseDataDic objectForKey:@"showGoodsList"];
            if (showGoodsList.count > 0) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:showGoodsList];
            }
        }else if ([[self.appraiseDataDic objectForKey:@"isComment"] intValue] == 1) {
            //未评论商品列表
            NSArray *orderDtlList = [self.appraiseDataDic objectForKey:@"orderDtlList"];
            if (orderDtlList.count > 0) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:orderDtlList];
            }
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
            [self.view addSubview:_tableView];
            _tableView.backgroundColor = [UIColor whiteColor];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            [_tableView setTableHeaderView:_headerView];
            [_tableView setTableFooterView:[UIView new]];
            [_tableView registerNib:[UINib nibWithNibName:@"AppraiseSuccessCell" bundle:nil] forCellReuseIdentifier:@"AppraiseSuccess_tableView_cell"];
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
            [_tableView setSeparatorColor:[ResourceManager color_5]];
        }
        
    }
    
}

-(void)layoutUI{
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 156 * ScaleSize)];
    [_headerView addSubview:bgImgView];
    bgImgView.image = [UIImage imageNamed:@"Tab_4-41"];
    bgImgView.userInteractionEnabled = YES;
    
    UIButton *appraiseSuccessBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 20, 150, 30)];
    [bgImgView addSubview:appraiseSuccessBtn];
    [appraiseSuccessBtn setTitle:@"评价成功" forState:UIControlStateNormal];
    [appraiseSuccessBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appraiseSuccessBtn setImage:[UIImage imageNamed:@"Tab_4-42"] forState:UIControlStateNormal];
    appraiseSuccessBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [appraiseSuccessBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(appraiseSuccessBtn.frame) + 5, SCREEN_WIDTH, 40)];
    [bgImgView addSubview:titleLabel];
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"已获得0积分\n坚持写有图评价，赚更多积分吧~";
    if ([self.appraiseDataDic objectForKey:@"commScore"]) {
        titleLabel.text = [NSString stringWithFormat:@"已获得%@积分\n坚持写有图评价，赚更多积分吧~",[self.appraiseDataDic objectForKey:@"commScore"]];
    }
    
    UIButton *backHomeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 110, CGRectGetMaxY(titleLabel.frame) + 10, 100, 35)];
    [bgImgView addSubview:backHomeBtn];
    backHomeBtn.layer.cornerRadius = 35/2;
    backHomeBtn.layer.borderWidth = 0.5;
    backHomeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    backHomeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backHomeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [backHomeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backHomeBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *checkAppraiseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, CGRectGetMaxY(titleLabel.frame) + 10, 100, 35)];
    [bgImgView addSubview:checkAppraiseBtn];
    checkAppraiseBtn.layer.cornerRadius = 35/2;
    checkAppraiseBtn.layer.borderWidth = 0.5;
    checkAppraiseBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    checkAppraiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [checkAppraiseBtn setTitle:@"查看评价" forState:UIControlStateNormal];
    [checkAppraiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkAppraiseBtn addTarget:self action:@selector(checkAppraise) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 250)/2, CGRectGetMaxY(bgImgView.frame) + 30 - 0.5, 250, 1)];
    [_headerView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager mainColor];
    
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, CGRectGetMaxY(bgImgView.frame) + 20, SCREEN_WIDTH, 40)];
    [_headerView addSubview:subTitleLabel];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.font = [UIFont systemFontOfSize:14];
    subTitleLabel.textColor = [ResourceManager color_1];
    
    if ([[self.appraiseDataDic objectForKey:@"isComment"] intValue] == 0) {
        //推荐商品列表
      subTitleLabel.text = @"接着评论下去吧";
    }else if ([[self.appraiseDataDic objectForKey:@"isComment"] intValue] == 1) {
        //未评论商品列表
      subTitleLabel.text = @"你可能还想买";
    }
    
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(subTitleLabel.frame) + 10);
}

//返回首页
-(void)backHome{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(1)}];
}

//查看评价
-(void)checkAppraise{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(1)}];
}


#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppraiseSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppraiseSuccess_tableView_cell"];
    if (!cell) {
        cell = [[AppraiseSuccessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppraiseSuccess_tableView_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.appraiseBlock = ^{
        //评价
        IssueAppraiseViewController *ctl = [[IssueAppraiseViewController alloc]init];
        ctl.orderDataDic = dic;
        [self.navigationController pushViewController:ctl animated:YES];
    };
    
    cell.dataDicionary = dic;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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

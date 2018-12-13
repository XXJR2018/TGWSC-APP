//
//  TabViewController_2.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_2.h"

@interface TabViewController_2 ()
{
    UIScrollView *_scView;
    UIButton *_sortFirstBtn;
    UIView *_sortFristView;
    NSMutableArray *_sortFirstTitleArr;
    NSMutableArray *_sortFirstBtnArr;
}
@end

@implementation TabViewController_2

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"分类"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"分类"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideBackButton = YES;
    [self layoutNaviBarViewWithTitle:@"分类"];
    _sortFirstBtnArr = [NSMutableArray array];
    _sortFirstTitleArr = [NSMutableArray arrayWithArray:@[@"冬季专区",@"爆品专区",@"新品专区",@"居家",@"鞋包配饰",@"服装",@"洗护",@"饮食",@"母婴",@"餐厨",@"保健",@"文体",@"12.12专区",@"特色区"]];
    [self layoutUI];
}

-(void)layoutUI{
    
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, 100, SCREEN_HEIGHT - NavHeight - TabbarHeight)];
    [self.view addSubview:_scView];
    _scView.backgroundColor = [UIColor whiteColor];
    _scView.bounces = NO;
    _scView.pagingEnabled = NO;
    _scView.showsVerticalScrollIndicator = NO;
    
    UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_scView.frame) - 0.5, 0, 0.5, CGRectGetMaxY(_scView.frame))];
    [_scView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    
    for (int i = 0; i < _sortFirstTitleArr.count; i ++) {
        _sortFirstBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50 * i, 100, 50)];
        [_scView addSubview:_sortFirstBtn];
        _sortFirstBtn.tag = i + 100;
        [_sortFirstBtn setTitle:_sortFirstTitleArr[i] forState:UIControlStateNormal];
        [_sortFirstBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [_sortFirstBtn setTitleColor:[ResourceManager redColor1] forState:UIControlStateSelected];
        _sortFirstBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sortFirstBtn addTarget:self action:@selector(sortFirstTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [_sortFirstBtnArr addObject:_sortFirstBtn];
        
    }
    
    _scView.contentSize =CGSizeMake(0, CGRectGetMaxY(_sortFirstBtn.frame) + 10);
    ((UIButton *)_sortFirstBtnArr[0]).selected = YES;
    _sortFristView = [[UIView alloc]initWithFrame:CGRectMake(0, (50 - 20)/2, 2, 20)];
    [_scView addSubview:_sortFristView];
    _sortFristView.backgroundColor = [ResourceManager redColor1];
    
}

#pragma mark-一级菜单点击事件
-(void)sortFirstTouch:(UIButton *)sender{
    
    if (sender == _sortFirstBtn) {
        return;
    }
    NSLog(@"%@",_sortFirstTitleArr[sender.tag - 100]);
    ((UIButton *)_sortFirstBtnArr[0]).selected = NO;
    if (sender != _sortFirstBtn) {
        _sortFirstBtn.selected = NO;
        _sortFirstBtn = sender;
    }else{
        //避免重复点击
        return;
    }
    _sortFirstBtn.selected = YES;
    _sortFristView.frame = CGRectMake(0, (50 - 20)/2 + (sender.tag - 100) * 50, 2, 20);
}

-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

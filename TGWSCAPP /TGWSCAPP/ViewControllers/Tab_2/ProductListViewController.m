//
//  ProductListViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/20.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ProductListViewController.h"

@interface ProductListViewController ()
{
    UIButton *_sortBtn;
    NSMutableArray *_sortBtnArr;
    UIView *_sortViewX;
}
@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"母婴"];
    
    _sortBtnArr = [NSMutableArray array];
    
    [self layoutUI];
    [self scViewUI];
    
}

-(void)layoutUI{
    
}

-(void)scViewUI{
   UIScrollView *scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 40)];
    [self.view addSubview:scView];
    scView.backgroundColor = [UIColor whiteColor];
    scView.bounces = NO;
    scView.pagingEnabled = NO;
    scView.showsVerticalScrollIndicator = NO;
    
    
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSDictionary *dic = self.sortDataArr[i];
        _sortBtn = [[UIButton alloc]initWithFrame:CGRectMake(80 * i, 0, 80, 40)];
        [scView addSubview:_sortBtn];
        _sortBtn.tag = i;
        
        NSString *title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cateName"]];
        [_sortBtn setTitle:title forState:UIControlStateNormal];
        [_sortBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [_sortBtn setTitleColor:UIColorFromRGB(0x704a18) forState:UIControlStateSelected];
        _sortBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sortBtn addTarget:self action:@selector(sortFirstTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [_sortBtnArr addObject:_sortBtn];
    }
    
    scView.contentSize =CGSizeMake(CGRectGetMaxX(_sortBtn.frame) , 0);
    ((UIButton *)_sortBtnArr[0]).selected = YES;
    _sortViewX = [[UIView alloc]initWithFrame:CGRectMake(10, 40 -1, 60, 1)];
    [scView addSubview:_sortViewX];
    _sortViewX.backgroundColor = UIColorFromRGB(0x704a18);
    
}


#pragma mark-一级菜单点击事件
-(void)sortFirstTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    ((UIButton *)_sortBtnArr[0]).selected = NO;
    if (sender != _sortBtn) {
        _sortBtn.selected = NO;
        _sortBtn = sender;
    }
    _sortBtn.selected = YES;
    _sortViewX.frame = CGRectMake(80 * sender.tag + 10, 40 - 1, 60, 1);
    
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

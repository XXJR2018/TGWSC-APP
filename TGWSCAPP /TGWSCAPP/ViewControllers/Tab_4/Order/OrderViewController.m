//
//  OrderViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "OrderViewController.h"

#import "OrderListViewController.h"
#import "LSPPageView.h"


@interface OrderViewController ()<LSPPageViewDelegate>

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"我的订单"];
    
    [self layoutUI];
}

-(void)layoutUI{
    
    NSArray *titleArray = @[@"全部",@"代付款",@"代发货",@"已发货",@"已完成"];
    NSMutableArray *childVcArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        OrderListViewController *ctl = [[OrderListViewController alloc] init];
        [childVcArray addObject:ctl];
    }
    LSPPageView *pageView = [[LSPPageView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight) titles:titleArray.mutableCopy style:nil childVcs:childVcArray.mutableCopy parentVc:self];
    pageView.delegate = self;
    [pageView setToIndex:self.orderIndex];
    pageView.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:pageView];
    
}

#pragma mark - LSPPageViewDelegate
- (void)pageViewScollEndView:(LSPPageView *)pageView WithIndex:(NSInteger)index{
    NSLog(@"第%zd个",index);
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

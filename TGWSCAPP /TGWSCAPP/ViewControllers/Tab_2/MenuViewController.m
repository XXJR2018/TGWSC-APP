//
//  MenuViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/21.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "MenuViewController.h"

#import "LSPPageView.h"
#import "ProductListViewController.h"

@interface MenuViewController ()<LSPPageViewDelegate>

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:self.titleStr];
    
    [self layoutUI];
}

-(void)layoutUI{
    
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dic in self.sortDataArr) {
        [titleArray addObject:[dic objectForKey:@"cateName"]];
    }

    NSMutableArray *childVcArray = [NSMutableArray array];
    for (int i = 0; i < self.sortDataArr.count; i++) {
        ProductListViewController *ctl = [[ProductListViewController alloc] init];
        NSDictionary *dic = self.sortDataArr[i];
        ctl.cateCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cateCode"]];
        [childVcArray addObject:ctl];
    }
    LSPPageView *pageView = [[LSPPageView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight) titles:titleArray.mutableCopy style:nil childVcs:childVcArray.mutableCopy parentVc:self];
    pageView.delegate = self;
    pageView.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:pageView];

    NSInteger count = 0;
    for (NSDictionary *dic in self.sortDataArr) {
        if ([[dic objectForKey:@"cateId"] intValue] == self.cateId) {
             [pageView setToIndex:count];
        }
        count ++;
    }
    
}


#pragma mark - LSPPageViewDelegate
- (void)pageViewScollEndView:(LSPPageView *)pageView WithIndex:(NSInteger)index
{
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

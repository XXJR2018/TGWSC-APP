//
//  TabViewController_1.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_1.h"
#import "SearchVC.h"
#import "HistoryAndCategorySearchVC.h"

@interface TabViewController_1 ()

@end

@implementation TabViewController_1

#pragma mark  ---   lifcycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"首页"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首页"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}


#pragma mark --- 布局UI
-(void)layoutUI{
    
    
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor purpleColor];
    [btn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
}

-(void) share
{
    
    //开始登录
//    if (![[DDGAccountManager sharedManager] isLoggedIn])
//     {
//        [DDGUserInfoEngine engine].parentViewController = self;
//        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
//        return;
//     }
//
//    SearchVC *VC = [[SearchVC alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
    
    HistoryAndCategorySearchVC *searShopVC = [HistoryAndCategorySearchVC new];
    
    //(1)点击分类 (2)用户点击键盘"搜索"按钮  (3)点击历史搜索记录
    [searShopVC beginSearch:^(NaviBarSearchType searchType,NBSSearchShopCategoryViewCellP *categorytagP,UILabel *historyTagLabel,LLSearchBar *searchBar) {
        //            @LLStrongObj(self);
        
        NSLog(@"historyTagLabel:%@--->searchBar:%@--->categotyTitle:%@--->%@",historyTagLabel.text,searchBar.text,categorytagP.categotyTitle,categorytagP.categotyID);
        
    }];
    //执行即时搜索匹配
    NSArray *tempArray =  @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    
    
    //@LLWeakObj(searShopVC);
    [searShopVC searchbarDidChange:^(NaviBarSearchType searchType, LLSearchBar *searchBar, NSString *searchText) {
        //@LLStrongObj(searShopVC);
        
        //FIXME:这里模拟网络请求数据!!!
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            searShopVC.resultListArray = tempArray;
        });
    }];
    
    //点击了即时匹配选项
    [searShopVC resultListViewDidSelectedIndex:^(UITableView *tableView, NSInteger index) {
        //            @LLStrongObj(self);
        NSLog(@"点击了即时搜索内容第%zd行的%@数据",index,tempArray[index]);
    }];
    
    [self.navigationController presentViewController:searShopVC animated:NO completion:nil];
    
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

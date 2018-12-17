//
//  TabViewController_1.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_1.h"
#import "HistoryAndCategorySearchVC.h"
#import "HistorySearchVC.h"
#import "CKSlideMenu.h"
#import "SlideParentVC.h"

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 布局头部
    [self layoutHead];
    
    
}

-(void) layoutHead
{
    // 布局头部
    int iTopY =  IS_IPHONE_X_MORE? 40:30;
    int iLeftX = 15;
    UIImageView *imgICON = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY +2, 50, 17)];
    [self.view addSubview:imgICON];
    imgICON.image = [UIImage imageNamed:@"Tab1_TGW"];
    
    // 搜索框
    iLeftX += imgICON.width + 10;
    UIView *viewSearch = [[UIView alloc] initWithFrame:CGRectMake(iLeftX , iTopY-5, SCREEN_WIDTH - iLeftX - 40, 30)];
    [self.view addSubview:viewSearch];
    viewSearch.cornerRadius = 5;
    viewSearch.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UITapGestureRecognizer * gestureSearch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSearch1)];
    gestureSearch.numberOfTapsRequired  = 1;
    viewSearch.userInteractionEnabled = YES;
    [viewSearch addGestureRecognizer:gestureSearch];
    
    UIImageView *imgSearch = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 17, 17)];
    [viewSearch addSubview:imgSearch];
    imgSearch.image = [UIImage imageNamed:@"Tab1_Search"];
    
    UILabel *labelSearch = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, viewSearch.width - 35, 20)];
    [viewSearch addSubview:labelSearch];
    labelSearch.font = [UIFont systemFontOfSize:14];
    labelSearch.textColor = [ResourceManager lightGrayColor];
    labelSearch.text = @"百里挑一的好商品";
    
    // 消息按钮
    UIButton *btnMessage = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, iTopY, 18, 20)];
    [self.view addSubview:btnMessage];
    [btnMessage setBackgroundImage:[UIImage imageNamed:@"Tab1_Message"] forState:UIControlStateNormal];
    [btnMessage addTarget: self action:@selector(actionMessage) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 滚动菜单
    iTopY += viewSearch.height ;
    //NSArray *titles = @[@"推荐",@"母婴",@"洗护",@"食品",@"医疗",@"粉丝",@"阿萨德",@"爱迪生",@"暗示",@"说的"];
    NSArray *titles = @[@"推荐",@"母婴",@"洗护",@"食品",@"医疗",@"医疗1",@"医疗2"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i <titles.count ; i++) {
        SlideParentVC *VC = [[SlideParentVC alloc] init];
        VC.slideModel = [SlideModel new];
        VC.slideModel.iSlideID = i;
        VC.slideModel.strSlideName = titles[i];
        [arr addObject:VC];
    }
    

    

    CKSlideMenu *slideMenu = [[CKSlideMenu alloc]initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH-30, 40) titles:titles controllers:arr];
    //slideMenu.backgroundColor = [UIColor yellowColor];
    if ([titles count] <= 5)
     {
        slideMenu.isFixed = TRUE; // 菜单固定
     }
    slideMenu.bodyFrame = CGRectMake(0,  iTopY + 40, self.view.frame.size.width, SCREEN_HEIGHT - 40 - iTopY- TabbarHeight);
    [slideMenu scrollToIndex:0];
    [self.view addSubview:slideMenu];
    
    
    UIButton *btnDonw = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, iTopY, 40, 40)];
    [self.view addSubview:btnDonw];
    //btnDonw.backgroundColor = [UIColor blueColor];
    //[btnAll setBackgroundImage:[UIImage imageNamed:@"com_down"] forState:UIControlStateNormal];
   
    UIImageView *imgDown = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18, 12, 7)];
    [btnDonw addSubview:imgDown];
    imgDown.image = [UIImage imageNamed:@"com_down"];
    
    
    
    
}


-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}



-(void) popMenu
{
    
}

#pragma mark ---  action
-(void) actionMessage
{
    NSLog(@"actionMessage");
}

-(void) actionSearch1
{
    HistorySearchVC *searShopVC = [HistorySearchVC alloc];
    
    

    //(1)点击分类 (2)用户点击键盘"搜索"按钮  (3)点击历史搜索记录
    [searShopVC beginSearch:^(NaviBarSearchType searchType,NBSSearchShopCategoryViewCellP *categorytagP,UILabel *historyTagLabel,LLSearchBar *searchBar) {
        
        NSLog(@"historyTagLabel:%@--->searchBar:%@--->categotyTitle:%@--->%@",historyTagLabel.text,searchBar.text,categorytagP.categotyTitle,categorytagP.categotyID);
        
        searShopVC.searchBarText = @"你选择的搜索内容显示到这里";
    }];
    
    //点击了即时匹配选项
    [searShopVC resultListViewDidSelectedIndex:^(UITableView *tableView, NSInteger index) {
        //            @LLStrongObj(self);
        NSLog(@"点击了即时搜索内容第%zd行的%@数据",index,searShopVC.resultListArray[index]);
    }];
    
    
    //执行即时搜索匹配
    NSArray *tempArray = @[@"Java", @"Python"];
    
    
    [searShopVC searchbarDidChange:^(NaviBarSearchType searchType, LLSearchBar *searchBar, NSString *searchText) {
        
        //FIXME:这里模拟网络请求数据!!!
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            searShopVC.resultListArray = tempArray;
        });
    }];
    
    
    
    [self.navigationController presentViewController:searShopVC animated:nil completion:nil];
}

-(void) actionSearch2
{
    HistoryAndCategorySearchVC *searShopVC = [HistoryAndCategorySearchVC alloc];
    //(1)点击分类 (2)用户点击键盘"搜索"按钮  (3)点击历史搜索记录
    [searShopVC beginSearch:^(NaviBarSearchType searchType,NBSSearchShopCategoryViewCellP *categorytagP,UILabel *historyTagLabel,LLSearchBar *searchBar) {
        
        NSLog(@"historyTagLabel:%@--->searchBar:%@--->categotyTitle:%@--->%@",historyTagLabel.text,searchBar.text,categorytagP.categotyTitle,categorytagP.categotyID);
        
    }];
    
    //点击了即时匹配选项
    [searShopVC resultListViewDidSelectedIndex:^(UITableView *tableView, NSInteger index) {
        
        //NSLog(@"点击了即时搜索内容第%zd行的%@数据",index,tempArray[index]);
        NSLog(@"点击了即时搜索内容第%zd行的%@数据",index,searShopVC.resultListArray[index]);
        
    }];
    
    //执行即时搜索匹配
    NSArray *tempArray =  @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];

    [searShopVC searchbarDidChange:^(NaviBarSearchType searchType, LLSearchBar *searchBar, NSString *searchText) {

        //FIXME:这里模拟网络请求数据!!!
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            searShopVC.resultListArray = tempArray;
        });
    }];
    

    
    [self.navigationController presentViewController:searShopVC animated:NO completion:nil];
}








@end

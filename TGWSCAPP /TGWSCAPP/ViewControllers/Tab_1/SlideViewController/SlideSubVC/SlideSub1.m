//
//  SlideSub1.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SlideSub1.h"
#import "CKSlideMenu.h"
#import "SDCycleScrollView.h"
#import "ShopListView.h"
#import "AdvertingShopListView.h"

#define  BANNER_HEIGHT       (170*ScaleSize)      // Banner的高度

@interface SlideSub1 ()<SDCycleScrollViewDelegate,AdvertingShopListViewDelegate,ShopListViewDelegate>
{
    UIScrollView *scView;
    
    SDCycleScrollView *_scrollView;      // 头部banner
    NSMutableArray *_bannerUrlArr;
    NSMutableArray *_bannerTitleArr;
}
@end

@implementation SlideSub1

#pragma mark --- lifecylce
-(void)viewWillAppear:(BOOL)animated
{
    [self getUIformWeb];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifScroll) name:SliedScrollNotification object:nil];
    //NSLog(@"SlideSub1  frame:%f", self.view.frame.size.height);
    
    
    // 首页只有一个sub时， 从此函数布局UI
    self.view.height = SCREEN_HEIGHT - 70  - TabbarHeight;
    
    [self layoutUI];
}


#pragma mark --- 布局UI
// view 已经布局其 Subviews
- (void)viewDidLayoutSubviews
{
    NSLog(@"SlideSub1 viewDidLayoutSubviews");
    //[self getUIformWeb];
    
    //[self layoutUI];
}


-(void) layoutUI
{
    NSLog(@"SlideSub1  frame:%f", self.view.frame.size.height);
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, self.view.frame.size.height)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 1000);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];//[ResourceManager viewBackgroundColor];
    
    // banner （商品）
    int iTopY = 0;
    int iLeftX = 0;
    if (!_scrollView){
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, BANNER_HEIGHT) imageNamesGroup:@[@"Tab1_Banner",@"Tab1_Banner"]];
        [scView addSubview:_scrollView];
    }
    _bannerTitleArr = [NSMutableArray arrayWithArray:@[@"商品1",@"商品2"]];
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.delegate = self;
    _scrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    
    // 底部商品说明
    iTopY += _scrollView.height;
    UIImage *imgSPSM = [UIImage imageNamed:@"Tab1_SPSM"];
    float fImgHeight = imgSPSM.size.height;
    NSLog(@"imgTest.size.height: %f, imgTest.size.width: %f" ,imgSPSM.size.height,imgSPSM.size.width);
    
    UIImageView *imgViewSPSM = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, fImgHeight *ScaleSize)];
    [scView addSubview:imgViewSPSM];
    imgViewSPSM.image = imgSPSM;

    
    // 推荐商品
    iTopY += imgViewSPSM.height;
    //NSArray *arrImg =@[@"Tab1_TJSP",@"Tab1_TJSP",@"Tab1_TJSP",@"Tab1_TJSP"];
    NSMutableArray  *tempArr = [[NSMutableArray alloc] init];
    for (int i = 0;  i < 6; i++)
     {
        ShopModel *sModel = [[ShopModel alloc] init];
        sModel.iShopID = i;
        sModel.strShopImgUrl = @"Tab1_TJSP";
        [tempArr addObject:sModel];
     }
    //NSArray *arrImg =@[@"Tab1_TJSP",@"Tab1_TJSP"];
    AdvertingShopListView  *adListView = [[AdvertingShopListView alloc] initWithTitle:@"推荐商品" itemArray:tempArr origin_Y:iTopY];
    [scView addSubview:adListView];
    adListView.delegate = self;
    
    
    // 热销商品
    NSMutableArray  *tempArr1 = [[NSMutableArray alloc] init];
    for (int i = 0;  i < 6; i++)
     {
        ShopModel *sModel = [[ShopModel alloc] init];
        sModel.iShopID = i;
        sModel.strShopImgUrl = @"Tab1_RMSP";
        sModel.strShopName = @"凯尔德乐婴儿";
        sModel.strPrice = @"¥ 13.90";
        [tempArr1 addObject:sModel];
     }
    iTopY += adListView.height;
    ShopListView  *shopListView1 = [[ShopListView alloc] initWithTitle:@"热销商品" itemArray:tempArr1  columnCount:3  origin_Y:iTopY];
    [scView addSubview:shopListView1];
    shopListView1.delegate = self;
    
    
    // 热销商品
    NSMutableArray  *tempArr2 = [[NSMutableArray alloc] init];
    for (int i = 0;  i < 6; i++)
     {
        ShopModel *sModel = [[ShopModel alloc] init];
        sModel.iShopID = i;
        sModel.strShopImgUrl = @"Tab1_RMSP";
        sModel.strShopName = @"凯尔德乐婴儿凯尔德乐婴儿凯尔德乐婴儿凯尔德乐婴儿";
        sModel.strPrice = @"¥ 13.90";
        [tempArr2 addObject:sModel];
     }
    iTopY += shopListView1.height;
    ShopListView  *shopListView2 = [[ShopListView alloc] initWithTitle:@"新品发售" itemArray:tempArr2  columnCount:3  origin_Y:iTopY];
    [scView addSubview:shopListView2];
    shopListView2.delegate = self;
    
    
    
    iTopY += shopListView2.height;
    scView.contentSize = CGSizeMake(0, iTopY);
    
    

}


/**
 *  banner 请求完成之后做布局
 */
-(void)layoutScrollViewAfter:(NSArray*)arr
{
    
    if (arr.count == 0) {
        return;
    }
    
    //请求接口后banner加载后台数据
    [_scrollView removeAllSubviews];
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 0, 15 *ScaleSize, SCREEN_WIDTH, BANNER_HEIGHT) delegate:nil placeholderImage:[UIImage imageNamed:@"Tab1_Banner"]];
    [self.view addSubview:_scrollView];
    
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    _bannerTitleArr = [[NSMutableArray alloc] init];
    _bannerUrlArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dic in arr)
     {
        NSString *name = dic[@"imgName"];
        NSString *imgUrl = dic[@"imgUrl"];
        NSString *skipUrl = dic[@"skipUrl"];
        [imgArr addObject:imgUrl];
        [_bannerTitleArr addObject:name];
        [_bannerUrlArr addObject:skipUrl];
        
     }
    _scrollView.imageURLStringsGroup = imgArr;
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.delegate = self;
    _scrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
}


#pragma mark --- 网络通讯
-(void)getUIformWeb
{
    //NSString *strUrl = [PDAPI getBannerAPI];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLqueryShowTypeList];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    
    if (operation.tag == 1000)
     {


     }

    

}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    
    
    
}


#pragma mark - delegate
//SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *titleStr = _bannerTitleArr[index];
//    if ([titleStr isEqualToString:@"抢单规则"]) {
//        [self ljqdAction];
//
//        return;
//    }else if ([titleStr isEqualToString:@"邀请好友"]){
//
//        if ([[DDGAccountManager sharedManager] isLoggedIn]) {
//            SharePrize *ctl = [[SharePrize alloc] init];
//            [self.navigationController pushViewController:ctl animated:YES];
//            return;
//        }else {
//            [DDGUserInfoEngine engine].parentViewController = self;
//            [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
//            return;
//        }
//
//
//    }
//    else if ([titleStr isEqualToString:@"充值"]) {
//        if ([[DDGAccountManager sharedManager] isLoggedIn]) {
//            VIPViewController *adVC = [[VIPViewController alloc] init];
//            NSDictionary *dic = [DDGAccountManager sharedManager].userInfo;
//            adVC.vipGrade = [[dic objectForKey:@"vipGrade"] integerValue];
//            adVC.usableAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usableAmount"]];
//            adVC.vipEndDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vipEndDate"]];
//            adVC.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realName"]];
//            adVC.imageUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userImage"]];
//            [self.navigationController pushViewController:adVC animated:YES];
//            return;
//        }else {
//            [DDGUserInfoEngine engine].parentViewController = self;
//            [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
//            return;
//        }
//
//    }else{
//        //如果不是以上两个，跳转相应h5页面
//        [CCWebViewController showWithContro:self withUrlStr:_bannerUrlArr[index] withTitle:_bannerTitleArr[index]];
//    }
}


// AdvertingShopListViewDelegate
-(void)didClickButtonAtObejct:(ShopModel*)clickObj
{
    if ([clickObj  isKindOfClass:[ShopModel class]])
     {
        int iShopID = clickObj.iShopID;
        // 点击更多按钮
        if (-1 == iShopID)
         {
            NSLog(@"Click More");
         }
        else
         {
            NSLog(@"ShopID:%d", iShopID);
         }
        
        
        //开始登录
        if (![[DDGAccountManager sharedManager] isLoggedIn])
         {
            [DDGUserInfoEngine engine].parentViewController = self;
            [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
            return;
         }
        
     }
}



// ShopListViewDelegate
-(void)didShopClickButtonAtObejct:(ShopModel*)clickObj
{
    if ([clickObj  isKindOfClass:[ShopModel class]])
     {
        int iShopID = clickObj.iShopID;
        // 点击更多按钮
        if (-1 == iShopID)
         {
            NSLog(@"Click More :%@", clickObj.strShopName);
         }
        else
         {
            NSLog(@"ShopID:%d", iShopID);
            NSLog(@"strShopName:%@", clickObj.strShopName);
         }
        
     }
}

#pragma mark  ---  Notification
-(void) notifScroll
{
    [self getUIformWeb];
}









@end

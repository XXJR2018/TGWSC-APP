//
//  SlideSub1.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SlideSub1.h"
#import "SDCycleScrollView.h"
#import "ShopListView.h"
#import "AdvertingShopListView.h"

#define  BANNER_HEIGHT       (170*ScaleSize)      // Banner的高度

@interface SlideSub1 ()<SDCycleScrollViewDelegate>
{
    UIScrollView *scView;
    
    SDCycleScrollView *_scrollView;      // 头部banner
    NSMutableArray *_bannerUrlArr;
    NSMutableArray *_bannerTitleArr;
}
@end

@implementation SlideSub1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSLog(@"SlideSub1  frame:%f", self.view.frame.size.height);
}


#pragma mark --- 布局UI
// view 已经布局其 Subviews
- (void)viewDidLayoutSubviews
{
    [self layoutUI];
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

    
    iTopY += imgViewSPSM.height;
    NSArray *arrImg =@[@"Tab1_TJSP",@"Tab1_TJSP",@"Tab1_TJSP",@"Tab1_TJSP"];
    AdvertingShopListView  *adListView = [[AdvertingShopListView alloc] initWithTitle:@"推荐商品" itemArray:arrImg origin_Y:iTopY];
    [scView addSubview:adListView];

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
-(void)fetchBanner{
    
    
    //NSString *strUrl = [PDAPI getBannerAPI];
    NSString *strUrl = @"https://newapp.xxjr.com/xxcust/comm/queryTheBanner";
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:@{@"type":@(2)} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                  }];
    operation.tag = 1003;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    
//    if (operation.tag == 1001)
//     {
//
//        _arrayProduct = operation.jsonResult.rows;
//        NSLog(@"_arrayProduct:%@", _arrayProduct);
//
//        [self setFrameAll];
//
//        [_produtTableView reloadData];
//
//
//     }
//    if (operation.tag == 1002)
//     {
//
//
//        NSArray *arr = operation.jsonResult.rows;
//        NSLog(@"arr:%@", arr);
//        [self setFKXX:arr];
//
//     }
    
    if (operation.tag == 1003)
     {
        NSArray *arr = [operation.jsonResult.attr objectForKey:@"bannerList"];
        NSLog(@"arr:%@", arr);
        // banner图返回数目大于等于2，才用后台的设置
        

//        if ([arr count] >=2)
//         {
//
//            [self layoutScrollViewAfter:arr];
//         }
     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    
    
    
}


#pragma mark - SDCycleScrollViewDelegate
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


#pragma mark --- action


@end

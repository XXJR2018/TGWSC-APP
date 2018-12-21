//
//  ShopDetailVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/21.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ShopDetailVC.h"
#import <AVFoundation/AVFoundation.h>
#import "TSVideoPlayback.h"

@interface ShopDetailVC ()<TSVideoPlaybackDelegate>
{
}

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer
@property (nonatomic,assign) int type;  // 0  图片，  1  视频和图片混合
@property (nonatomic,strong) TSVideoPlayback *video;

@end

@implementation ShopDetailVC

#pragma mark --- lifecylce
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"商品详情"];
    
    [self layoutUI];
    
    [self getDataFromWeb];
}

//清除缓存必须写
-(void)dealloc
{
    [self.video clearCache];
}

#pragma mark  ---   布局UI
-(void) layoutUI
{
    // 布局头部文件
    [self initialControlUnit];
    
}
-(void)initialControlUnit
{
    int iTopY = 40;
    iTopY = NavHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.video = [[TSVideoPlayback alloc] initWithFrame:CGRectMake(0, iTopY, self.view.frame.size.width, 300) ];
    self.video.delegate = self;
    self.type = 0;
    if (self.type == 1)
     {
        self.title = @"纯图片详情";
        [self.video setWithIsVideo:TSDETAILTYPEIMAGE andDataArray:[self imgArray]];
     }
    else{
        self.title = @"视频图片详情";
        [self.video setWithIsVideo:TSDETAILTYPEVIDEO andDataArray:[self bannerArray]];
    }
    [self.view addSubview:self.video];
    
    
    //UIView *viewTest = [UIView alloc] initWithFrame:CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
}

-(NSArray *)bannerArray
{
    return @[
             @"http://img.ptocool.com/video/2018-06-30_RGq4iDnu.mov",
             @"http://img.ptocool.com/3332-1518523974126-29",
             @"http://img.ptocool.com/3332-1518523974125-28",
             @"http://img.ptocool.com/3332-1518523974125-27",
             @"http://img.ptocool.com/3332-1518523974124-26"];
}
-(NSArray *)imgArray
{
    return @[
             @"http://img.ptocool.com/3332-1518523974126-29",
             @"http://img.ptocool.com/3332-1518523974125-28",
             @"http://img.ptocool.com/3332-1518523974125-27",
             @"http://img.ptocool.com/3332-1518523974124-26"];
}



#pragma mark --- 网络通讯
-(void) getDataFromWeb
{
    [self queryGoodsBaseInfo];
    //[self queryGoodsDetailInfo];
}

// 获取商品基本信息
-(void) queryGoodsBaseInfo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLqueryGoodsBaseInfo];
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

// 获取商品附加信息
-(void) queryGoodsDetailInfo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLqueryGoodsDetailInfo];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (operation.tag == 1000)
     {
//        NSArray *arrTitles   = operation.jsonResult.rows;
//        if (arrTitles&&
//            [arrTitles count] > 0)
//         {
//
//
//            int iCount = (int)[arrTitles count];
//            if (iCount > 0)
//             {
//                [titles removeAllObjects];
//
//                [self layoutMenu:arrTitles];
//
//
//             }
//         }
     }
    else if (operation.tag == 1001) {
        
        
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    //[MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}



#pragma mark - delegate
//TSVideoPlaybackDelegate  点击图片或者相片时，相应函数
-(void)videoView:(TSVideoPlayback *)view didSelectItemAtIndexPath:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
}




@end

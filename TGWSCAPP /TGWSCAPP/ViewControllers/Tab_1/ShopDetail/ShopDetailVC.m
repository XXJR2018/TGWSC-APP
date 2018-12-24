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


#define   BannerHeight     300
#define   ShopRedColor     UIColorFromRGB(0x9f1421)

@interface ShopDetailVC ()<TSVideoPlaybackDelegate>
{
    UIScrollView *scView;
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
    
    [self getDataFromWeb];
}

//清除缓存必须写
-(void)dealloc
{
    [self.video clearCache];
}

#pragma mark  ---   布局UI
-(void) layoutUI:(NSDictionary*) dicUI
{
    int iTopY = 40;
    iTopY = NavHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT- NavHeight - 60 )];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 2000);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];//[ResourceManager viewBackgroundColor];
    
    // 布局头部banner
    [self initialControlUnit];
    
    // 布局底部的tabbar
    [self layoutTabber];
    
    
    NSDictionary *dicBaseGoods = dicUI[@"baseGoods"];
    if(!dicBaseGoods ||
       [dicBaseGoods count] == 0)
     {
        return;
     }
    
    
    // 设置标题
    iTopY =  BannerHeight + 10;
    int iLeftX = 15;
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 25)];
    [scView addSubview:lableTitle];
    lableTitle.font = [UIFont systemFontOfSize:16];
    lableTitle.textColor = [ResourceManager color_1];
    lableTitle.text = dicBaseGoods[@"goodsName"];
    
    // 设置副标题
    iTopY += lableTitle.height + 10;
    UILabel *lableSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 15)];
    [scView addSubview:lableSubTitle];
    lableSubTitle.font = [UIFont systemFontOfSize:12];
    lableSubTitle.textColor = [ResourceManager midGrayColor];
    lableSubTitle.text = dicBaseGoods[@"goodsSubName"];
    
    // 设置价格
    iTopY += lableSubTitle.height + 10;
    int iPriceHeight = 25;
    UILabel *labelFH =  [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+1, 10, iPriceHeight)];
    [scView addSubview:labelFH];
    labelFH.font = [UIFont systemFontOfSize:18];
    labelFH.textColor = ShopRedColor;
    labelFH.text = @"¥";
    
    UILabel *lablePrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+15, iTopY, SCREEN_WIDTH - 2*iLeftX, iPriceHeight)];
    [scView addSubview:lablePrice];
    lablePrice.font = [UIFont systemFontOfSize:iPriceHeight];
    lablePrice.textColor = ShopRedColor;
    //lablePrice.text = dicBaseGoods[@"goodsSubName"];
    
    NSString *strMinPrice = [NSString stringWithFormat:@"%@", dicBaseGoods[@"minPrice"]];
    NSString *strMaxPrice = [NSString stringWithFormat:@"%@", dicBaseGoods[@"maxPrice"]];
    if ([strMinPrice isEqualToString:strMaxPrice])
     {
        lablePrice.text = [NSString stringWithFormat:@"%@",strMinPrice];
     }
    else
     {
        lablePrice.text = [NSString stringWithFormat:@"%@-%@",strMinPrice,strMaxPrice];
     }
    
    
    iTopY += lablePrice.height +10;
    
    //设置原价
    id  marketPrice =  dicBaseGoods[@"marketPrice"];
    NSString *strMarketPrice = [NSString stringWithFormat:@"¥%@",dicBaseGoods[@"marketPrice"]];
    if (marketPrice &&
        ![strMarketPrice isEqualToString:@"¥0"])
     {
        iTopY -= 5;
        
        UILabel *labelMarketPrice = [[UILabel alloc]  initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 20)];
        [scView addSubview:labelMarketPrice];
        labelMarketPrice.font = [UIFont systemFontOfSize:17];
        labelMarketPrice.textColor = [ResourceManager midGrayColor];
        
        //下划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:strMarketPrice attributes:attribtDic];
        labelMarketPrice.attributedText = attribtStr;

        iTopY += labelMarketPrice.height + 10;
     }
    
    // 设置分割线
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY-1, SCREEN_WIDTH - 2*iLeftX, 1)];
    [scView addSubview:viewFG1];
    viewFG1.backgroundColor = [ResourceManager color_5];
    
    // 设置包邮的价格
    iTopY += 15;
    UILabel *labelBY = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+3, 31, 15)];
    [scView addSubview:labelBY];
    labelBY.layer.masksToBounds = YES;
    labelBY.layer.cornerRadius = 3;
    labelBY.backgroundColor = [ResourceManager mainColor];
    labelBY.font = [UIFont systemFontOfSize:10];
    labelBY.textColor = [UIColor whiteColor];
    labelBY.text = @"  包邮";

    UILabel *labelBYJG = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 35, iTopY, 200, 20)];
    [scView addSubview:labelBYJG];
    labelBYJG.textColor = [ResourceManager color_1];
    labelBYJG.font = [UIFont systemFontOfSize:15];
    labelBYJG.text =  [NSString stringWithFormat:@"满%@元包邮", dicUI[@"maxPostFree"]];
    
    // 分割块
    iTopY += labelBY.height + 20;
    UIView *viewFGK1 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    [scView addSubview:viewFGK1];
    viewFGK1.backgroundColor = [ResourceManager viewBackgroundColor];
    
    // 优惠布局
    iTopY += viewFGK1.height + 10;
    UILabel *labelYHTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 40, 20)];
    [scView addSubview:labelYHTitle];
    labelYHTitle.textColor = [ResourceManager midGrayColor];
    labelYHTitle.font = [UIFont systemFontOfSize:12];
    labelYHTitle.text = @"优惠:";
    
    iLeftX += 40 ;
    UILabel *labelYH = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+3, 31, 15)];
    [scView addSubview:labelYH];
    //labelYH.layer.masksToBounds = YES;
    labelYH.layer.cornerRadius = 3;
    labelYH.borderColor = ShopRedColor;
    labelYH.borderWidth = 1;
    //labelYH.backgroundColor = [ResourceManager mainColor];
    labelYH.font = [UIFont systemFontOfSize:10];
    labelYH.textColor = ShopRedColor;
    labelYH.text = @"  积分";
    
    UILabel *labelGMJG = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 35, iTopY, 200, 20)];
    [scView addSubview:labelGMJG];
    labelGMJG.textColor = [ResourceManager color_1];
    labelGMJG.font = [UIFont systemFontOfSize:15];
    labelGMJG.text =  [NSString stringWithFormat:@"购买可得%d积分",  [dicBaseGoods[@"maxPrice"] intValue]];
    

    
    // 分割块
    iTopY += labelGMJG.height + 10;
    UIView *viewFGK2 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    [scView addSubview:viewFGK2];
    viewFGK2.backgroundColor = [ResourceManager viewBackgroundColor];
    
    // 已选布局


    
    
    
}
-(void)initialControlUnit
{
    self.video = [[TSVideoPlayback alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BannerHeight) ];
    self.video.delegate = self;
    self.type = 1;
    if (self.type == 1)
     {
        self.title = @"纯图片详情";
        [self.video setWithIsVideo:TSDETAILTYPEIMAGE andDataArray:[self imgArray]];
     }
    else
     {
        self.title = @"视频图片详情";
        [self.video setWithIsVideo:TSDETAILTYPEVIDEO andDataArray:[self bannerArray]];
     }
    [scView addSubview:self.video];
    

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


-(void) layoutTabber
{
    int iTopY = SCREEN_HEIGHT - 60;
    UIView *viewTabber = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 60)];
    [self.view addSubview:viewTabber];
    //viewTabber.backgroundColor = [UIColor yellowColor];
    
    iTopY = 0;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [viewTabber addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    
    NSArray *arrTitle =  @[@"客 服",@"收 藏",@"购物车"];
    NSArray *arrImg =  @[@"Shop_kf",@"Shop_shoucang",@"Shop_che"];
    
    int iLeftX = 12;
    iTopY = 13;
    for (int i = 0; i < [arrTitle count]; i++)
     {
        UIImageView *imgKF = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 16, 16)];
        [viewTabber addSubview:imgKF];
        imgKF.image = [UIImage imageNamed:arrImg[i]];
        
        UILabel *labelKF = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX - 10 , iTopY + 20, 40 , 15)];
        [viewTabber addSubview:labelKF];
        //labelKF.backgroundColor = [UIColor blueColor];
        labelKF.font = [UIFont systemFontOfSize:11];
        labelKF.textAlignment = NSTextAlignmentCenter;
        labelKF.textColor = [ResourceManager color_1];
        labelKF.text = arrTitle[i];
        
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX - 10, iTopY, 33, 40)];
        [viewTabber addSubview:btnTemp];
        //btnTemp.backgroundColor = [UIColor blueColor];
        btnTemp.tag = i;
        [btnTemp addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        iLeftX +=  36;
        
     }
    
    int iBtnWidth =  (SCREEN_WIDTH - iLeftX  - 3*10) /2;
    UIButton *btnLJGM = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 10, iBtnWidth, 40)];
    [viewTabber addSubview:btnLJGM];
    btnLJGM.layer.borderColor = [ResourceManager mainColor].CGColor;
    btnLJGM.layer.borderWidth = 1;
    btnLJGM.cornerRadius = btnLJGM.height/2;
    [btnLJGM setTitle:@"立即购买" forState:UIControlStateNormal];
    [btnLJGM setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnLJGM.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLJGM addTarget:self action:@selector(actionLJGM) forControlEvents:UIControlEventTouchUpInside];
    
    iLeftX += iBtnWidth + 10;
    UIButton *btnJRGWC = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 10, iBtnWidth, 40)];
    [viewTabber addSubview:btnJRGWC];
    //btnLJGM.layer.borderColor = [ResourceManager mainColor].CGColor;
    //btnLJGM.layer.borderWidth = 1;
    btnJRGWC.cornerRadius = btnJRGWC.height/2;
    btnJRGWC.backgroundColor = ShopRedColor;
    [btnJRGWC setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btnJRGWC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnJRGWC.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnJRGWC addTarget:self action:@selector(actionJRGWC) forControlEvents:UIControlEventTouchUpInside];
    
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
    [MBProgressHUD showHUDAddedTo:self.view];
    
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
        NSDictionary *dicUI = operation.jsonResult.attr;
        if (!dicUI)
         {
            [MBProgressHUD showErrorWithStatus:@"服务器忙，请稍后" toView:self.view];
            return;
         }
        [self layoutUI:dicUI];
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
    if (1000 == operation.tag)
     {
        [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
     }
}



#pragma mark - delegate
//TSVideoPlaybackDelegate  点击图片或者相片时，相应函数
-(void)videoView:(TSVideoPlayback *)view didSelectItemAtIndexPath:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
}

#pragma mark --- action
-(void) actionBtn:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    NSLog(@"iTag :%d", iTag);
}

-(void) actionLJGM
{
    
}

-(void) actionJRGWC
{
    
}



@end

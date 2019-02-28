//
//  ShareShopJpegView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/28.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "ShareShopJpegView.h"

@implementation ShareShopJpegView
{
    UIScrollView * scrolView;
    UILabel  *labelIndex;
    
    NSArray *arrImgURL;
    NSMutableArray *arrImg;
    int iCurNO;
    
    NSString *qrcodeUrl; // 商品二维码图片
}

-(ShareShopJpegView*) initWithArrImg:(NSArray *)arr   withNo:(int) iNo
{
    self =  [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    arrImgURL = arr;
    
    iCurNO = iNo;
    
    arrImg = [[NSMutableArray alloc] init];
    
    _shopModel = [[ShopModel alloc] init];
    
    [self drawUI];
    
    return self;
}

-(void) drawUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.85];
    
    int iTopY = 70;
    int iLeftX = 15;
    UIButton *btnSaveAllImg = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 50)];
    [self addSubview:btnSaveAllImg];
    [btnSaveAllImg setTitle:@"  保存全部图片" forState:UIControlStateNormal];
    btnSaveAllImg.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSaveAllImg setImage:[UIImage imageNamed:@"com_download"] forState:UIControlStateNormal];
    [btnSaveAllImg addTarget:self action:@selector(actionSaveAll) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnColse = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - iLeftX - 50, iTopY, 50, 50)];
    [self addSubview:btnColse];
    [btnColse setImage:[UIImage imageNamed:@"com_colse3"] forState:UIControlStateNormal];
    [btnColse addTarget:self action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
    
    // 布局图片
    scrolView = [[UIScrollView alloc]init];
    scrolView.pagingEnabled  = YES;
    scrolView.delegate = self;
    scrolView.showsVerticalScrollIndicator = NO;
    scrolView.showsHorizontalScrollIndicator = NO;
    scrolView.userInteractionEnabled = YES;
    
    scrolView.alwaysBounceVertical = NO;
    scrolView.alwaysBounceHorizontal = NO;
    
    [self addSubview:scrolView];
    scrolView.frame = CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_WIDTH);
    scrolView.backgroundColor = [UIColor whiteColor];
    
    
    for (int i = 0; i < arrImgURL.count; i ++)
     {
        
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        
        //int iBetwwen = 20;
        //UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH + iBetwwen, 0, SCREEN_WIDTH - 2*iBetwwen, SCREEN_WIDTH - 2*iBetwwen)];
        
        img.userInteractionEnabled = YES;
        
        [img sd_setImageWithURL:[NSURL URLWithString:arrImgURL[i]] ];
        
        [arrImg addObject:img];
        
        [scrolView addSubview:img];
     }
    
    scrolView.contentSize = CGSizeMake(arrImgURL.count*SCREEN_WIDTH, 0);
    
    labelIndex.text = [NSString stringWithFormat:@"%d/%d",(int)iCurNO,(int)arrImgURL.count];
    
    if (iCurNO > 1)
     {
        [scrolView setContentOffset:CGPointMake((iCurNO-1)*SCREEN_WIDTH,0) animated:YES];
     }
    
    
}


// 得到商品的分享的图片 （带二维码）
-(void) getShareQrcode
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLgetXcxQrcode];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      //[self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      //[self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1000;
    //[operation start];
    
    
    qrcodeUrl = [operation.URL absoluteString];
}

#pragma mark --- action
-(void) actionClose
{
    [self removeAllSubviews];
    [self removeFromSuperview];
    self.hidden = YES;
}

-(void) actionSaveAll
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

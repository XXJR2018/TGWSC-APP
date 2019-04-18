//
//  ShopSecKillMoreVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/4/16.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "ShopSecKillMoreVC.h"
#import "ShopSecKillDetailVC.h"

@interface ShopSecKillMoreVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIColor *priceColor;
    UIColor *workInColor;  // 进行中背景色
    UIColor *workEndColor; // 已经结束背景色
    UIColor *workBeginColor; // 距离开始背景色
    
    NSMutableArray *arrTime;        // 定时器的计数器
    NSMutableArray *arrTimeLable;   // 定时器的显示label
}

@property (nonatomic, strong) UITableView *tableView;

// 倒计时计时器
@property(nonatomic,strong)NSTimer *countDownTimer;

@end

@implementation ShopSecKillMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    CustomNavigationBarView *nav =   [self layoutNaviBarViewWithWhiteTitle:_strTypeName];
    nav.backgroundColor = workInColor;
    
    
    
    [self layoutUI];
}

-(void)initData
{
    priceColor = UIColorFromRGB(0x79191f);
    workInColor = UIColorFromRGB(0xa9454f);
    workEndColor = UIColorFromRGB(0xbdb9ba);
    workBeginColor =  UIColorFromRGB(0xcb9e6d);
    
    arrTime = [[NSMutableArray alloc] init];
    arrTimeLable = [[NSMutableArray alloc] init];
}


-(void) layoutUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark === 网络通讯
-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"typeCode"] = _strTypeCode;
    //params[@"cateCode"] = _strTypeCode;
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kURLquerySecKillAllList];
    
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strURL
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    //[_collectionView.mj_header endRefreshing];
    [self initData];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:operation.jsonResult.rows];
    
    // 初始化倒计时label 数组
    for (int i = 0; i < [self.dataArray count]; i++ )
     {
        UILabel *lableTime = [[UILabel alloc] init];
        [arrTimeLable addObject:lableTime];
     }
    
    [_tableView reloadData];
    
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    //[_collectionView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ?: 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return  tableView.height;
    }
    
    float fTopY = 10 * ScaleSize;
    float fLeftX = 10 * ScaleSize;
    float fImgBettewn = 5 * ScaleSize;
    float fImgHeight = (SCREEN_WIDTH - 2*fLeftX - (3 -1)* fImgBettewn) / 3 + 20;
    float fBottomHeight = 25;
    float fCellHeight = fTopY + fImgHeight + fBottomHeight + fTopY;
    
    return fCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    
    UITableViewCell *cell = nil;//  [tableView dequeueReusableCellWithIdentifier:@"ShopSecKill_Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopSecKill_Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    int iNO = (int)indexPath.row;
    [self layoutCell:cell withData:self.dataArray[iNO]   withNO:iNO];
    
    // 如果是最后一个cell ，开始倒计时
    if (iNO ==  [self.dataArray count] - 1)
     {
        [self creatCountDownTimer];
     }
    
    return cell;
}

-(UITableViewCell *)noDataCell:(UITableView *)tableView{
    static NSString * cellID = @"noDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
     {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
    
    [self noDataView:cell.contentView];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void) layoutCell:(UIView*) viewCell   withData:(NSDictionary *) dicValue   withNO:(int) iValue
{
    float fLeftX = 10 * ScaleSize;
    float fImgBettewn = 5 * ScaleSize;
    float fImgHeight = (SCREEN_WIDTH - 2*fLeftX - (3 -1)* fImgBettewn) / 3 + 20;
    float fImgWidth = fImgHeight;
    
    float fTopY = 10 * ScaleSize;
    float fImgTopY = fTopY;
    float fImgLeftX = fLeftX;
    
    // 左边的图片
    UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
    [viewCell  addSubview:imgViewTemp];
    
    ShopModel *sModel= [self getShopModelForDic:dicValue];
    NSString *strImgName = sModel.strGoodsImgUrl;
    [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:strImgName]];
    
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY+fImgWidth, fImgWidth, 25)];
    [viewCell addSubview:viewBottom];
    viewBottom.backgroundColor = workInColor;
    
    UILabel *labelBottom1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 40, viewBottom.height)];
    [viewBottom addSubview:labelBottom1];
    labelBottom1.textColor = [UIColor whiteColor];
    labelBottom1.font = [UIFont systemFontOfSize:11];
    labelBottom1.text = @"距结束";
    
    UILabel *labelBottom2 = arrTimeLable[iValue];
    labelBottom2.frame = CGRectMake(45, 0, viewBottom.width - 45 -5, viewBottom.height);
    [viewBottom addSubview:labelBottom2];
    labelBottom2.textColor = [UIColor whiteColor];
    labelBottom2.font = [UIFont systemFontOfSize:11];
    labelBottom2.textAlignment = NSTextAlignmentRight;
    labelBottom2.text = @"";
    
    // 加入倒计时的label
    //[arrTimeLable addObject:labelBottom2];
    // 加入倒计时的秒数
    NSNumber *numCountDownSecond = [NSNumber numberWithInt:sModel.iCountDownSecond];
    [arrTime addObject:numCountDownSecond];
    
    
    //右边的文字
    float  fLabLeftX = fLeftX + 2*fImgBettewn + fImgWidth;
    float  fLabTopY = fImgTopY + 10;
    float  fLabWidth = SCREEN_WIDTH - 2*fImgBettewn - fLabLeftX;
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(fLabLeftX, fLabTopY, fLabWidth, 40)];
    [viewCell  addSubview:labelName];
    labelName.font = [UIFont systemFontOfSize:15];
    labelName.textColor = [ResourceManager color_1];
    labelName.numberOfLines = 0;
    labelName.text = sModel.strGoodsName;
    
    fLabTopY += labelName.height + 10;
    UILabel *labelYH = [[UILabel alloc] initWithFrame:CGRectMake(fLabLeftX, fLabTopY, 200, 20)];
    [viewCell  addSubview:labelYH];
    labelYH.backgroundColor = UIColorFromRGB(0xf8eae9);
    labelYH.font = [UIFont systemFontOfSize:11];
    labelYH.textColor = [ResourceManager priceColor];
    labelYH.text = [NSString stringWithFormat:@" 减%@元 ", sModel.reducePrice] ;
    labelYH.layer.borderColor = UIColorFromRGB(0xccb9bd).CGColor;
    labelYH.layer.borderWidth = 0.6;
    labelYH.layer.masksToBounds = YES;
    labelYH.layer.cornerRadius = 2;
    [labelYH sizeToFit];
    labelYH.height = 20;
    
    float fLabeSubLeftX = fLabLeftX + labelYH.width + 5;
    UILabel *labelSubName = [[UILabel alloc] initWithFrame:CGRectMake(fLabeSubLeftX, fLabTopY , fLabWidth - labelYH.width -10, 20)];
    [viewCell  addSubview:labelSubName];
    labelSubName.font = [UIFont systemFontOfSize:14];
    labelSubName.textColor = [ResourceManager midGrayColor];
    labelSubName.text = sModel.strGoodsSubName;
    
    
    fLabTopY += labelSubName.height + 15;
    UILabel *labelSeckillStock = [[UILabel alloc] initWithFrame:CGRectMake(fLabLeftX, fLabTopY , fLabWidth, 20)];
    [viewCell  addSubview:labelSeckillStock];
    labelSeckillStock.font = [UIFont systemFontOfSize:13];
    labelSeckillStock.textColor = [ResourceManager midGrayColor];
    labelSeckillStock.text = [NSString stringWithFormat:@"仅剩%d件", sModel.iSeckillStock];
    
    fLabTopY += labelSeckillStock.height + 20;
    UILabel *labelSeckillPricee = [[UILabel alloc] initWithFrame:CGRectMake(fLabLeftX, fLabTopY, fLabWidth, 40)];
    [viewCell  addSubview:labelSeckillPricee];
    labelSeckillPricee.font = [UIFont systemFontOfSize:18];
    labelSeckillPricee.textColor = [ResourceManager priceColor];
    labelSeckillPricee.text =  [NSString stringWithFormat:@"¥%@",sModel.seckillPrice];
    [labelSeckillPricee sizeToFit];
    
    
    UILabel *labelMinPrice = [[UILabel alloc] initWithFrame:CGRectMake(fLabLeftX + labelSeckillPricee.width + 5, fLabTopY, fLabWidth, 40)];
    [viewCell  addSubview:labelMinPrice];
    labelMinPrice.font = [UIFont systemFontOfSize:15];
    labelMinPrice.textColor = [ResourceManager midGrayColor];
    NSString *strMinePrice =  [NSString stringWithFormat:@"¥%@",sModel.strMinPrice];
    // 中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:strMinePrice attributes:attribtDic];
    labelMinPrice.attributedText = attribtStr;
    [labelMinPrice sizeToFit];
    
    float fLabelBuywidth = 70;
    float fLabelBuyLeftX = fLabLeftX + fLabWidth - fLabelBuywidth;
    UILabel *labelBuy = [[UILabel alloc] initWithFrame:CGRectMake(fLabelBuyLeftX, fLabTopY-5 , fLabelBuywidth, 30)];
    [viewCell  addSubview:labelBuy];
    labelBuy.font = [UIFont systemFontOfSize:16];
    labelBuy.textColor = [UIColor whiteColor];
    labelBuy.backgroundColor = workInColor;
    labelBuy.textAlignment = NSTextAlignmentCenter;
    labelBuy.text = @"马上抢";
    
    
    
    //活动状态(0进行中 1已结束 2未开始 3已失效)
    int secKillStatus = sModel.iSecKillStatus;
    if (secKillStatus == 2)
     {
        labelBottom1.text = @"距开始";
        viewBottom.backgroundColor = workBeginColor;
        
        labelBuy.backgroundColor = [ResourceManager blackGrayColor];
        labelBuy.text = @"未开始";
     }
    else if (secKillStatus == 1)
     {
        labelBottom1.text = @"已结束";
        viewBottom.backgroundColor = workEndColor;
        
        labelBuy.backgroundColor = workEndColor;
        labelBuy.text = @"已抢光";
     }
    if (secKillStatus == 0)
     {
        labelBottom1.text = @"距结束";
        viewBottom.backgroundColor = workInColor;
        
        labelBuy.backgroundColor = workInColor;
        labelBuy.text = @"马上抢";
     }
    

    
   
}

-(ShopModel*) getShopModelForDic:(NSDictionary *) dicObject
{
    ShopModel *sModel = [[ShopModel alloc] init];
    //sModel.iShopID = ;
    sModel.strGoodsImgUrl =  [NSString stringWithFormat:@"%@",dicObject[@"imgUrl"]];
    sModel.strMinPrice = [NSString stringWithFormat:@"%@", [ToolsUtlis getnumber:[dicObject objectForKey:@"minPrice"]]];
    sModel.strMaxPrice = [NSString stringWithFormat:@"%@",[ToolsUtlis getnumber:[dicObject objectForKey:@"maxPrice"]]];
    sModel.strGoodsCode = [NSString stringWithFormat:@"%@",dicObject[@"goodsCode"]];
    sModel.strGoodsName = [NSString stringWithFormat:@"%@",dicObject[@"goodsName"]];
    sModel.strGoodsSubName = [NSString stringWithFormat:@"%@",dicObject[@"goodsSubName"]];
    sModel.strCateCode = [NSString stringWithFormat:@"%@",dicObject[@"cateCode"]];
    sModel.strCateName = [NSString stringWithFormat:@"%@",dicObject[@"cateName"]];
    sModel.iIsSellOut = [dicObject[@"isSellOut"] intValue];
    sModel.iSaleStatus = [dicObject[@"isSellOut"] intValue];
    
    // 活动时，特别添加的字段
    sModel.iSkipType = [dicObject[@"skipType"] intValue];
    sModel.strSkipUrl = [NSString stringWithFormat:@"%@",dicObject[@"skipUrl"]];
    
    // 限购和秒杀活动时， 特别添加的字端
    sModel.iSeckillId = [dicObject[@"seckillId"] intValue]; // 活动ID
    sModel.iSecKillStatus = [dicObject[@"secKillStatus"] intValue];  // 活动状态(0未开始 1进行中 2已结束 3已失效)
    sModel.iQuota = [dicObject[@"quota"] intValue];  // 是否限购；0为不限购 其他为限购数量
    sModel.iSeckillStock = [dicObject[@"seckillStock"] intValue];  // 秒杀商品剩余件数
    sModel.iCountDownSecond = [dicObject[@"countDownSecond"] intValue]; // 剩余秒数
    sModel.minPrice = [ToolsUtlis getnumber:dicObject[@"minPrice"]];  // 原价
    sModel.seckillPrice = [ToolsUtlis getnumber:dicObject[@"seckillPrice"]]; // 秒杀价
    sModel.reducePrice = [ToolsUtlis getnumber:dicObject[@"reducePrice"]]; //价差（减xx元）
    
    return sModel;
}

#pragma mark ---  UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    //活动状态(0进行中 1已结束 2未开始 3已失效)
    int secKillStatus = [dic[@"secKillStatus"] intValue];
    if (0 == secKillStatus)
     {
        ShopModel *shopModel = [self getShopModelForDic:dic];
        
        ShopSecKillDetailVC  *VC = [[ShopSecKillDetailVC alloc] init];
        VC.shopModel = shopModel;
        [self.navigationController pushViewController:VC animated:YES];
        
     }
}

#pragma mark   --- 定时器相关
-(void) creatCountDownTimer
{
    [self stopCountDownTimer];
    
    // 每一秒执行一次方法
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showCountDown) userInfo:nil repeats:YES];
    
    [_countDownTimer fire];
    
    // 解决定时器后台 无法运行的BUG
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    [[NSRunLoop currentRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
}

-(void) stopCountDownTimer
{
    if (_countDownTimer)
     {
        //取消定时器
        [_countDownTimer invalidate];
        _countDownTimer = nil;
     }
}

-(void) showCountDown
{
    
    for (int i = 0; i < [self.dataArray count]; i++)
     {
        UILabel *labelTemp = arrTimeLable[i];
        if (!labelTemp)
         {
            continue;
         }
        
        
        NSNumber *numCountDownSecond = arrTime[i];
        int iCountDownSecond = [numCountDownSecond intValue];
        
        if (iCountDownSecond <= 0)
         {
            labelTemp.text = @"0天00:00:00";
            continue;
         }
        
        // 计算总共还有 X天X小时X分X秒
        int iDay = iCountDownSecond/(24*60*60);
        int iOtherSFM = iCountDownSecond - iDay*24*60*60;  // 去除天后，剩余的时分秒
        int iHour = iOtherSFM/ (60*60);
        int iOherFM = iOtherSFM - iHour *60*60;
        int iMiuter = iOherFM/60;
        int iSecond = iCountDownSecond%60;
        
        labelTemp.text = [NSString stringWithFormat:@"%d天%02d:%02d:%02d",iDay,iHour,iMiuter,iSecond];
        
        
        if (iCountDownSecond >= 0)
         {
            iCountDownSecond--;
         }
        numCountDownSecond = [NSNumber numberWithInt:iCountDownSecond];
        // 替换元素
        [arrTime replaceObjectAtIndex:i withObject:numCountDownSecond];
        
     }
    
}

@end

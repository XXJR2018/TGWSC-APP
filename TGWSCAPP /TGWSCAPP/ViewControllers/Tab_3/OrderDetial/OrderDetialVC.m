//
//  OrderDetialVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/3.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "OrderDetialVC.h"
#import "AddressViewController.h"

#define        AddrViewHeight        70
#define        BottomViewHeight      50

@interface OrderDetialVC ()
{
    UIScrollView  *scView;
    
    UIView *viewBottom;   // 底部view
    UIView *viewNoAddr;
    UIView *viewHaveAddr;
    UIView *viewList;   // 商品列表view
    UIView *viewTail;   // 底部详情view
    
    NSDictionary *dicOfUI;
    NSArray *arrOfUI;
    

}
@end

@implementation OrderDetialVC

#pragma mark ---  lifecycle
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"订单详情页面"];
    
    [self getUIDataFromWeb];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"订单详情页面"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initData];
    
    [self layoutNaviBarViewWithTitle:@"确认订单"];
    
    [self getUIDataFromWeb];
}

-(void) initData
{
    dicOfUI = nil;
    arrOfUI = nil;
}

#pragma mark --- 布局UI
-(void) layoutUI:(NSDictionary*) dicValue  andArr:(NSArray*)arrValue
{
    // 布局底部按钮
    [self layoutBottomView];
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight - BottomViewHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 1000);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    int iTopY = 0;
    int iLeftX = 0;
    
    UIImageView *imgCiaoTiao = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 3)];
    [scView addSubview:imgCiaoTiao];
    imgCiaoTiao.image = [UIImage imageNamed:@"od_caitiao"];
    
    iTopY += imgCiaoTiao.height;
    //  布局无地址view
    [self layoutNoAddrAtLeftX:iLeftX AtTopY:iTopY];
    
    // 布局有地址view
    [self layoutHaveAddrAtLeftX:iLeftX AtTopY:iTopY  AddrDic:dicOfUI];
    
    int iHasAddr = [dicOfUI[@"hasAddr"] intValue];
    if (0 == iHasAddr)
     {
        viewNoAddr.hidden = NO;
        viewHaveAddr.hidden = YES;
     }
    else
     {
        viewNoAddr.hidden = YES;
        viewHaveAddr.hidden = NO;
     }
    
    iTopY += AddrViewHeight + 10;
    // 布局商品列表
    [self layoutShopListAtLeftX:iLeftX AtTopY:iTopY AndArr:arrOfUI];
    
    iTopY += viewList.height;
    // 布局底部详情view
    [self layoutTailViewAtLeftX:iLeftX AtTopY:iTopY AndDic:dicOfUI];
    
    
//    // 画虚线
//    UIImageView * lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 100, SCREEN_WIDTH, 1)];
//    [scView addSubview:lineView1];
//    lineView1.image = [ToolsUtlis imageWithLineWithImageView:lineView1];
    
}

//  布局无地址view
-(void) layoutNoAddrAtLeftX:(int) iLeftValue  AtTopY:(int ) iTopValue
{
    viewNoAddr = [[UIView alloc] initWithFrame:CGRectMake(iLeftValue, iTopValue, SCREEN_WIDTH, AddrViewHeight)];
    [scView addSubview:viewNoAddr];
    viewNoAddr.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelNoAddr = [[UILabel alloc] initWithFrame:CGRectMake(15, viewNoAddr.height/4, SCREEN_WIDTH-30, viewNoAddr.height/2)];
    [viewNoAddr addSubview:labelNoAddr];
    labelNoAddr.textColor = [ResourceManager priceColor];
    labelNoAddr.font = [UIFont systemFontOfSize:15];
    labelNoAddr.text = @"没有地址信息，请点击后添加地址";
    
    UIButton *btnAddr = [[UIButton alloc] initWithFrame:viewNoAddr.bounds];
    [viewNoAddr addSubview:btnAddr];
    [btnAddr addTarget:self action:@selector(actionAddr) forControlEvents:UIControlEventTouchUpInside];
    
}

// 布局有地址view
-(void) layoutHaveAddrAtLeftX:(int) iLeftValue  AtTopY:(int ) iTopValue  AddrDic:(NSDictionary*)dicValue
{
    NSDictionary *dicAddrInfo = dicValue[@"addrInfo"];
    if (!dicAddrInfo)
     {
        dicAddrInfo = [[NSDictionary alloc] init];
     }
    
    viewHaveAddr = [[UIView alloc] initWithFrame:CGRectMake(iLeftValue, iTopValue, SCREEN_WIDTH, AddrViewHeight)];
    [scView addSubview:viewHaveAddr];
    viewHaveAddr.backgroundColor = [UIColor whiteColor];
    
    int iTopY = 10;
    int iLeftX = 15;
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 20)];
    [viewHaveAddr addSubview:labelName];
    labelName.textColor = [ResourceManager color_1];
    labelName.font = [UIFont systemFontOfSize:14];
    labelName.text = dicAddrInfo[@"receiveName"];
    
    UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 170, iTopY, 130, 20)];
    [viewHaveAddr addSubview:labelPhone];
    labelPhone.textColor = [ResourceManager color_1];
    labelPhone.textAlignment = NSTextAlignmentRight;
    labelPhone.font = [UIFont systemFontOfSize:14];
    labelPhone.text = dicAddrInfo[@"receiveTel"];
    
    iTopY += labelName.height ;
    UILabel *labelAddr = [[UILabel alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH - 50, 30)];
    [viewHaveAddr addSubview:labelAddr];
    labelAddr.textColor = [ResourceManager color_1];
    labelAddr.font = [UIFont systemFontOfSize:11];
    labelAddr.numberOfLines = 0;
    labelAddr.text = dicAddrInfo[@"fullAddrDesc"];
    
    
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, (AddrViewHeight - 19*ScaleSize)/2, 11*ScaleSize, 19*ScaleSize)];
    [viewHaveAddr addSubview:imgRight];
    imgRight.image = [UIImage imageNamed:@"arrow_right"];
    
    UIButton *btnAddr = [[UIButton alloc] initWithFrame:viewHaveAddr.bounds];
    [viewHaveAddr addSubview:btnAddr];
    [btnAddr addTarget:self action:@selector(actionAddr) forControlEvents:UIControlEventTouchUpInside];
    
}

// 布局商品列表
-(void) layoutShopListAtLeftX:(int) iLeftValue  AtTopY:(int ) iTopValue  AndArr:(NSArray*) arrValue
{
    viewList = [[UIView alloc] initWithFrame:CGRectMake(iLeftValue, iTopValue, SCREEN_WIDTH, 100)];
    [scView addSubview:viewList];
    viewList.backgroundColor = [UIColor whiteColor];
    
    int iShopCount = (int)[arrValue count];
    int iCellHeight = 95;
    int iCellTopY = 0;
    for (int i = 0; i < iShopCount; i++)
     {
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iCellTopY, SCREEN_WIDTH, iCellHeight)];
        [viewList addSubview:viewCell];
        //viewCell.backgroundColor = [UIColor whiteColor];
        
        NSDictionary *objGood = arrValue[i];
        
        int iTopY = 10;
        int iLeftX = 15;
        UIImageView *imgShop = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 75, 75)];
        [viewCell addSubview:imgShop];
        [imgShop setImageWithURL:[NSURL URLWithString:objGood[@"goodsUrl"]]];
        
        iTopY += 5;
        iLeftX += imgShop.width + 10;
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, 20)];
        [viewCell addSubview:labelName];
        labelName.textColor = [ResourceManager color_1];
        labelName.font = [UIFont systemFontOfSize:14];
        labelName.text = objGood[@"goodsName"];
        
        
        iTopY += labelName.height + 5;
        UILabel *labelGuige = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, 20)];
        [viewCell addSubview:labelGuige];
        labelGuige.textColor = [ResourceManager midGrayColor];
        labelGuige.font = [UIFont systemFontOfSize:11];
        labelGuige.text = objGood[@"skuDesc"];
        
        iTopY += labelGuige.height + 5;
        UILabel *labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10 - 60, 20)];
        [viewCell addSubview:labelPrice];
        labelPrice.textColor = [ResourceManager priceColor];
        labelPrice.font = [UIFont systemFontOfSize:15];
        labelPrice.text =   [NSString stringWithFormat:@"¥%@",objGood[@"price"]];
        
        
        UILabel *lableNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, iTopY, 50, 20)];
        [viewCell addSubview:lableNum];
        lableNum.textColor = [ResourceManager midGrayColor];
        lableNum.font = [UIFont systemFontOfSize:15];
        lableNum.textAlignment = NSTextAlignmentRight;
        lableNum.text =   [NSString stringWithFormat:@"×%@",objGood[@"num"]];
        
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(15, iCellHeight-1, SCREEN_WIDTH - 2*15, 1)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
        iCellTopY += iCellHeight;
     }
    
    viewList.height = iCellTopY;
    
}


// 布局底部详情view
-(void) layoutTailViewAtLeftX:(int) iLeftValue  AtTopY:(int ) iTopValue  AndDic:(NSDictionary*) dicValue
{
    viewTail = [[UIView alloc] initWithFrame:CGRectMake(iLeftValue, iTopValue, SCREEN_WIDTH, 100)];
    [scView addSubview:viewTail];
    
    int iTopY = 0;
    int iLeftX = 15;
    UILabel *labelMJYY = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 60, 40)];
    [viewTail addSubview:labelMJYY];
    labelMJYY.font = [UIFont systemFontOfSize:14];
    labelMJYY.textColor = [ResourceManager color_1];
    labelMJYY.text = @"买家留言";
    labelMJYY.backgroundColor = [ResourceManager redColor1];
}

// 布局底部按钮view
- (void)layoutBottomView
{
    viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BottomViewHeight, SCREEN_WIDTH, BottomViewHeight)];
    [self.view addSubview:viewBottom];
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    lineView.backgroundColor = [ResourceManager color_5];
    [viewBottom addSubview:lineView];
    
    int iLeftX = 15;
    int iTopY = 10;
    UILabel *lableHJ = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 50, 20)];
    [viewBottom addSubview:lableHJ];
    lableHJ.textColor = [ResourceManager color_1];
    lableHJ.font = [UIFont systemFontOfSize:14];
    lableHJ.text = @"合计:";

    
    iLeftX += lableHJ.width;
    UILabel *lableTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX,iTopY , SCREEN_HEIGHT-iLeftX-120, 20)];
    [viewBottom addSubview: lableTotalPrice];
    lableTotalPrice.textColor = [ResourceManager priceColor];
    lableTotalPrice.font = [UIFont systemFontOfSize:18];
    lableTotalPrice.text = @"¥150.00";
    
    iTopY += lableTotalPrice.height;
    UILabel *lableYHPrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX,iTopY , SCREEN_HEIGHT-iLeftX-120, 15)];
    [viewBottom addSubview: lableYHPrice];
    lableYHPrice.textColor = [ResourceManager midGrayColor];
    lableYHPrice.font = [UIFont systemFontOfSize:12];
    lableYHPrice.text = @"已优惠: ¥50.00";
    
    

    //结算按钮
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 0, 120, BottomViewHeight)];
    [viewBottom addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager priceColor];
    [btnOK setTitle:@"去支付" forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnOK addTarget:self action:@selector(actionPay) forControlEvents:UIControlEventTouchUpInside];
    

//
//    //合计
//    UILabel *label = [[UILabel alloc]init];
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [ResourceManager priceColor];
//    [backgroundView addSubview:label];
//
//    label.attributedText = [self LZSetString:@"¥0.00"];
//    CGFloat maxWidth = LZSCREEN_WIDTH - selectAll.bounds.size.width - btn.bounds.size.width - 30;
//    //    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, LZTabBarHeight)];
//    label.frame = CGRectMake(selectAll.bounds.size.width + 20, 0, maxWidth - 10, LZTabBarHeight);
//    self.totlePriceLabel = label;
}



#pragma mark --- 网络请求
-(void) getUIDataFromWeb
{
    dicOfUI = nil;
    arrOfUI = nil;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params = _dicToWeb;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLsingleOrderInfo];
    if (2 == _iType)
     {
        strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLbatchOrderInfo];
     }
    
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

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (operation.tag == 1000)
     {
        dicOfUI = operation.jsonResult.attr;
        arrOfUI = operation.jsonResult.rows;
        [self layoutUI:dicOfUI andArr:arrOfUI];
     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}


#pragma mark  ---  action
-(void) actionAddr
{
    AddressViewController *ctl = [[AddressViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}


-(void) actionPay
{
    
}
@end

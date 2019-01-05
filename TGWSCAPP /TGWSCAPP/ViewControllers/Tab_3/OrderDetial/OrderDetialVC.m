//
//  OrderDetialVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/3.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "OrderDetialVC.h"
#import "AddressViewController.h"
#import "SelCouponVC.h"
#import "SelPayVC.h"
#import "PayResultVC.h"

#define        AddrViewHeight        70
#define        BottomViewHeight      50

@interface OrderDetialVC ()<UITextFieldDelegate>
{
    UIScrollView  *scView;
    
    UIView *viewBottom;   // 底部view
    UIView *viewNoAddr;
    UIView *viewHaveAddr;
    UIView *viewList;   // 商品列表view
    UIView *viewTail;   // 底部详情view
    
    UILabel *lableYHJ;
    
    NSDictionary *dicOfUI;
    NSArray *arrOfUI;
    BOOL isCheckXY;  // 协议勾选标记位
    
    float promocardValue;  // 优惠券的面值
    float goodsTotalAmt;   // 商品的总价值
    
 

}

@property (nonatomic,assign) BOOL  isNotLoadData;     // 不需要加载数据
@property (nonatomic, strong) NSString *custPromocardId;  // 优惠券的唯一ID

@end

@implementation OrderDetialVC

#pragma mark ---  lifecycle
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订单详情页面"];
    
    if (!_isNotLoadData)
     {
        [self getUIDataFromWeb];
     }
    _isNotLoadData = NO;
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
    promocardValue = 0;
    goodsTotalAmt = 0;
    _custPromocardId = @"";
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

    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
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
    int iCellHeight = 50;
    // 买家留言
    UIView *viewMJLY = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, iCellHeight)];
    [viewTail addSubview:viewMJLY];
    viewMJLY.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelMJYY = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 60, iCellHeight)];
    [viewTail addSubview:labelMJYY];
    labelMJYY.font = [UIFont systemFontOfSize:14];
    labelMJYY.textColor = [ResourceManager color_1];
    labelMJYY.text = @"买家留言";
    
    iLeftX += labelMJYY.width+10;
    UITextField  *textMJLY = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, iCellHeight)];
    [viewTail addSubview:textMJLY];
    textMJLY.font = [UIFont systemFontOfSize:14];
    textMJLY.textColor = [ResourceManager color_1];
    textMJLY.placeholder = @"填写内容需与商家协商并确认，45字以内";
    textMJLY.tag = 1000;
    textMJLY.delegate = self;
    
    // @"优惠券/优惠码",@"购买所得积分",@"配送方式" 布局
    iTopY += iCellHeight + 10;
    NSArray *arrName = @[@"优惠券/优惠码",@"购买所得积分",@"配送方式"];
    
    for(int i= 0 ; i <[arrName count]; i++)
     {
        iLeftX = 15;
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [viewTail addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 150, iCellHeight)];
        [viewCell addSubview:labelName];
        labelName.font = [UIFont systemFontOfSize:14];
        labelName.textColor = [ResourceManager color_1];
        labelName.text = arrName[i];
        
        
        if (0 == i)
         {
            //优惠券特殊编码
            lableYHJ = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 80, 20)];
            [viewCell addSubview:lableYHJ];
            lableYHJ.font = [UIFont systemFontOfSize:14];
            lableYHJ.textColor = [ResourceManager midGrayColor];
            lableYHJ.textAlignment = NSTextAlignmentRight;
            lableYHJ.text = @"暂无可用";
            
            UILabel *lableYHJ2 = [[UILabel alloc] initWithFrame:CGRectMake(110, (iCellHeight-20)/2, 60, 20)];
            [viewCell addSubview:lableYHJ2];
            lableYHJ2.font = [UIFont systemFontOfSize:13];
            lableYHJ2.textColor = [UIColor whiteColor];
            lableYHJ2.text = @"";
            lableYHJ2.textAlignment = NSTextAlignmentCenter;
            lableYHJ2.backgroundColor = [ResourceManager priceColor];
            lableYHJ2.hidden = YES;
            
            
            NSArray *arr = dicOfUI[@"promocardList"];
            if (arr &&
                [arr count] >0)
             {
                lableYHJ2.hidden = NO;
                lableYHJ2.text = [NSString stringWithFormat:@"可选%ld张",[arr count]];
                lableYHJ.text = [NSString stringWithFormat:@"-¥%.2f",promocardValue]; // 优惠券的面值
    
             }

            
            UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, (iCellHeight - 19*ScaleSize)/2, 11*ScaleSize, 19*ScaleSize)];
            [viewCell addSubview:imgRight];
            imgRight.image = [UIImage imageNamed:@"arrow_right"];
            
            
            //添加手势, 选择券
            UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelQuan)];
            gesture.numberOfTapsRequired  = 1;
            [viewCell addGestureRecognizer:gesture];
            
         }
        else if(1 == i)
         {
            // 购买所得积分
            UILabel *labelJF = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 90, 20)];
            [viewCell addSubview:labelJF];
            labelJF.font = [UIFont systemFontOfSize:14];
            labelJF.textColor = [ResourceManager midGrayColor];
            labelJF.textAlignment = NSTextAlignmentRight;
            labelJF.text = [NSString stringWithFormat:@"%@", dicValue[@"scorePrice"]];
         }
        else if (2 == i)
         {
            // 配送方式
            UILabel *labelPSFS = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 90, 20)];
            [viewCell addSubview:labelPSFS];
            labelPSFS.font = [UIFont systemFontOfSize:14];
            labelPSFS.textColor = [ResourceManager midGrayColor];
            labelPSFS.textAlignment = NSTextAlignmentRight;
            labelPSFS.text = [NSString stringWithFormat:@"%@",dicValue[@"deliveryType"]];
         }
            
        
        if (i < ([arrName count] - 1))
         {
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iCellHeight-1, SCREEN_WIDTH, 1)];
            [viewCell addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager color_5];
         }
        
        iTopY += iCellHeight;
     }
    
    
    iTopY += 10;
    arrName = @[@"商品总价",@"运费"];
    for(int i= 0 ; i <[arrName count]; i++)
     {
        iLeftX = 15;
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [viewTail addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 150, iCellHeight)];
        [viewCell addSubview:labelName];
        labelName.font = [UIFont systemFontOfSize:14];
        labelName.textColor = [ResourceManager color_1];
        labelName.text = arrName[i];
        
        
        
        if(0 == i)
         {
            // 商品总价
            UILabel *labelSPZJ = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 90, 20)];
            [viewCell addSubview:labelSPZJ];
            labelSPZJ.font = [UIFont systemFontOfSize:14];
            labelSPZJ.textColor = [ResourceManager priceColor];
            labelSPZJ.textAlignment = NSTextAlignmentRight;
            labelSPZJ.text = [NSString stringWithFormat:@"¥%@",dicValue[@"goodsTotalAmt"]];
         }
        else if (1 == i)
         {
            // 运费
            UILabel *labelYF = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 90, 20)];
            [viewCell addSubview:labelYF];
            labelYF.font = [UIFont systemFontOfSize:14];
            labelYF.textColor = [ResourceManager priceColor];
            labelYF.textAlignment = NSTextAlignmentRight;
            labelYF.text = [NSString stringWithFormat:@"¥%@",dicValue[@"postage"]];
         }
        
        
        if (i < ([arrName count] - 1))
         {
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iCellHeight-1, SCREEN_WIDTH, 1)];
            [viewCell addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager color_5];
         }
        
        iTopY += iCellHeight;
     }
    
    iTopY += 20;
    iLeftX = 15;
    UIButton *btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX,iTopY, 20, 20)];
    [viewTail addSubview:btnCheck];
    [btnCheck setImage:[UIImage imageNamed:@"sc_gou1"] forState:UIControlStateNormal];
    [btnCheck setImage:[UIImage imageNamed:@"sc_gou2"] forState:UIControlStateSelected];
    btnCheck.selected = YES;
    [btnCheck addTarget:self action:@selector(actionCheck:) forControlEvents:UIControlEventTouchUpInside];
    
    iLeftX += btnCheck.width +10;
    UILabel *labelXY1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 58, 20)];
    [viewTail addSubview:labelXY1];
    labelXY1.textColor = [ResourceManager midGrayColor];
    labelXY1.font = [UIFont systemFontOfSize:14];
    labelXY1.text = @"我已同意";
    
    iLeftX += labelXY1.width;
    UILabel *labelXY2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [viewTail addSubview:labelXY2];
    labelXY2.textColor = [ResourceManager color_1];
    labelXY2.font = [UIFont systemFontOfSize:14];
    labelXY2.text = @"《天狗窝商城服务协议》";
    
    
    iTopY += btnCheck.height +20;
    viewTail.height = iTopY;
    
    scView.contentSize = CGSizeMake(0, iTopY + iTopValue);
    
    
    
   
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
    lableTotalPrice.text = [NSString stringWithFormat:@"¥%.2f", goodsTotalAmt - promocardValue];

    
    iTopY += lableTotalPrice.height;
    UILabel *lableYHPrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX,iTopY , SCREEN_HEIGHT-iLeftX-120, 15)];
    [viewBottom addSubview: lableYHPrice];
    lableYHPrice.textColor = [ResourceManager midGrayColor];
    lableYHPrice.font = [UIFont systemFontOfSize:12];
    lableYHPrice.text = [NSString stringWithFormat:@"已优惠: ¥%.2f", promocardValue];//@"已优惠: ¥50.00";
    
    

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
    [self initData];
    [MBProgressHUD showHUDAddedTo:self.view];
    
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
        
        promocardValue = [dicOfUI[@"promocardValue"] floatValue];
        goodsTotalAmt = [dicOfUI[@"goodsTotalAmt"] floatValue];
        if (dicOfUI[@"custPromocardId"])
         {
            _custPromocardId = [NSString stringWithFormat:@"%@", dicOfUI[@"custPromocardId"]];
         }
        
        [self layoutUI:dicOfUI andArr:arrOfUI];
     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}


#pragma mark  ---  action
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}


-(void) actionAddr
{
    AddressViewController *ctl = [[AddressViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}


-(void) actionPay
{
    NSLog(@"actionPay");
    SelPayVC  *VC = [[SelPayVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
    //PayResultVC *VC = [[PayResultVC alloc] init];
    //[self.navigationController pushViewController:VC animated:YES];
    
}


-(void) actionSelQuan
{
    NSLog(@"actionSelQuan");
    if (dicOfUI)
     {
        NSArray *arr = dicOfUI[@"promocardList"];
        if (arr &&
            [arr count] >0)
         {
            SelCouponVC *VC = [[SelCouponVC alloc] init];
            VC.arrCoupon = arr;
            VC.custPromocardId = _custPromocardId;
            
            __weak OrderDetialVC *weakSelf = self;
            
            VC.sel_bolck = ^(id obj) {

                weakSelf.isNotLoadData = YES;
                
                //  没有优惠券
                if (!obj)
                 {
                    [self noYHQAfterSel];
                 }
                else
                 {
                    [self haveYHQAfterSel:obj];
                 }
            };
            
            [self.navigationController pushViewController:VC animated:YES];
            
         }
     }
}

-(void)  noYHQAfterSel
{
    promocardValue = 0;
    lableYHJ.text = @"不用券"; // 优惠券的面值
    [self layoutBottomView];
    
}

-(void)  haveYHQAfterSel:(NSDictionary *) dicValue
{
    promocardValue = [dicValue[@"promocardValue"] floatValue];
    _custPromocardId = [NSString stringWithFormat:@"%@", dicValue[@"custPromocardId"]];
    lableYHJ.text = [NSString stringWithFormat:@"-¥%.2f",promocardValue]; // 优惠券的面值
    
    [self layoutBottomView];
    
}

-(void) actionCheck:(UIButton*) sender
{
    sender.selected = !sender.selected;
    isCheckXY = sender.selected;
}

#pragma mark === UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (1000 == textField.tag)
     {
        [scView setContentOffset:CGPointMake(0,200) animated:YES];
     }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (1000 == textField.tag)
     {
        [scView setContentOffset:CGPointMake(0,0) animated:YES];
     }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (1000 == textField.tag)
     {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        if(textField.text.length >= 45) {
            //输入的字符个数大于45，则无法继续输入，返回NO表示禁止输入
            [MBProgressHUD showErrorWithStatus:@"输入字符长度大于45" toView:self.view];
            return NO;
        } else {
            return YES;
        }
     }
    return YES;
}

@end

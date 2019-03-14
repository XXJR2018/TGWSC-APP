//
//  RechargeViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/11.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RechargeViewController.h"

@interface RechargeViewController ()
{
    UIScrollView *_scView;
    UILabel *_balanceLabel;
    
    UIButton *_amountBtn;
    NSMutableArray *_amountBtnArr;
    NSInteger _rechargeAmount;
    
    UIButton *_zfbPayBtn;
    UIButton *_wxPayBtn;
    
}
@end

@implementation RechargeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"充值"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"充值"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"充值"];
    [self layoutUI];
}

-(void)layoutUI{
    
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_scView];
    _scView.backgroundColor = [UIColor whiteColor];
    _scView.showsVerticalScrollIndicator = NO;
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 251 * ScaleSize)];
    [_scView addSubview:bgImgView];
    bgImgView.image = [UIImage imageNamed:@"Recharge-1"];
    
    UILabel *balanceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40 * ScaleSize, 70 * ScaleSize, 100, 30)];
    [bgImgView addSubview:balanceTitleLabel];
    balanceTitleLabel.font = [UIFont systemFontOfSize:14];
    balanceTitleLabel.textColor = [UIColor whiteColor];
    balanceTitleLabel.text = @"当前余额（元）";
    
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(balanceTitleLabel.frame), CGRectGetMaxY(balanceTitleLabel.frame), 200, 50)];
    [bgImgView addSubview:_balanceLabel];
    _balanceLabel.font = [UIFont boldSystemFontOfSize:35];
    _balanceLabel.textColor = [UIColor whiteColor];
    _balanceLabel.text = @"1200";
    
    UIView *rechargeView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(bgImgView.frame) - 40, 2, 15)];
    [_scView addSubview:rechargeView];
    rechargeView.backgroundColor = UIColorFromRGB(0xD8B576);
    
    UILabel *rechargeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rechargeView.frame)+ 5, CGRectGetMidY(rechargeView.frame) - 10, 100, 20)];
    [_scView addSubview:rechargeTitleLabel];
    rechargeTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    rechargeTitleLabel.textColor = [ResourceManager color_1];
    rechargeTitleLabel.text = @"充值金额";
    
    CGFloat btnWidth = 160 * ScaleSize;
    CGFloat btnHeight = 81 * ScaleSize;
    NSArray *rechargeNumArr = @[@"100元",@"200元",@"500元",@"1000元"];
    NSArray *rechargetitleArr = @[@"赠送100元购物劵",@"赠送200元购物劵",@"赠送500元购物劵",@"赠送1000元购物劵"];
    _amountBtnArr = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            _amountBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - btnWidth * 2)/2 + btnWidth * j, CGRectGetMaxY(rechargeTitleLabel.frame) + 20 + btnHeight * i, btnWidth, btnHeight)];
            [_scView addSubview:_amountBtn];
            [_amountBtn setImage:[UIImage imageNamed:@"Recharge-2"] forState:UIControlStateNormal];
            [_amountBtn setImage:[UIImage imageNamed:@"Recharge-3"] forState:UIControlStateSelected];
            [_amountBtn setImage:[UIImage imageNamed:@"Recharge-2"] forState:UIControlStateHighlighted];
            [_amountBtn setImage:[UIImage imageNamed:@"Recharge-3"] forState:UIControlStateSelected | UIControlStateHighlighted];
            _amountBtn.tag = i * 2 + j;
            [_amountBtn addTarget:self action:@selector(amountTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15 * ScaleSize, _amountBtn.frame.size.width, 30)];
            [_amountBtn addSubview:numLabel];
            numLabel.font = [UIFont boldSystemFontOfSize:16];
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.textColor = [ResourceManager color_1];
            numLabel.text = rechargeNumArr[i * 2 + j];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numLabel.frame), _amountBtn.frame.size.width, 20)];
            [_amountBtn addSubview:titleLabel];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [ResourceManager color_6];
            titleLabel.text = rechargetitleArr[i * 2 + j];
            
            [_amountBtnArr addObject:_amountBtn];
        }
    }
    ((UIButton *)_amountBtnArr[2]).selected = YES;
    _rechargeAmount = 500;
    
    for (int i = 0; i < 2; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_amountBtn.frame) + 25 + 50 * i, 20, 20)];
        [_scView addSubview:imgView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+ 5, CGRectGetMidY(imgView.frame) - 10, 100, 20)];
        [_scView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [ResourceManager color_1];
        
        if (i == 0) {
            imgView.image = [UIImage imageNamed:@"Recharge-4"];
            titleLabel.text = @"支付宝支付";
            _zfbPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, CGRectGetMidY(imgView.frame) - 10, 20, 20)];
            [_scView addSubview:_zfbPayBtn];
            [_zfbPayBtn setImage:[UIImage imageNamed:@"Tab_4-25"] forState:UIControlStateNormal];
            [_zfbPayBtn setImage:[UIImage imageNamed:@"Tab_4-26"] forState:UIControlStateSelected];
            _zfbPayBtn.tag = i;
            [_zfbPayBtn addTarget:self action:@selector(payTypeTouch:) forControlEvents:UIControlEventTouchUpInside];
            _zfbPayBtn.selected = YES;
        }else{
            imgView.image = [UIImage imageNamed:@"Recharge-5"];
            titleLabel.text = @"微信支付";
            _wxPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, CGRectGetMidY(imgView.frame) - 10, 20, 20)];
            [_scView addSubview:_wxPayBtn];
            [_wxPayBtn setImage:[UIImage imageNamed:@"Tab_4-25"] forState:UIControlStateNormal];
            [_wxPayBtn setImage:[UIImage imageNamed:@"Tab_4-26"] forState:UIControlStateSelected];
            _wxPayBtn.tag = i;
            [_wxPayBtn addTarget:self action:@selector(payTypeTouch:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    UIImageView *rechargeImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 309 * ScaleSize)/2, CGRectGetMaxY(_wxPayBtn.frame) + 20, 309 * ScaleSize, 63.5 * ScaleSize)];
    [_scView addSubview:rechargeImg];
     rechargeImg.image = [UIImage imageNamed:@"Recharge-6"];
    rechargeImg.userInteractionEnabled = YES;
    
    UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, rechargeImg.frame.size.width, rechargeImg.frame.size.height)];
    [rechargeImg addSubview:rechargeBtn];
    [rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rechargeBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *rechargeTreatyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(rechargeImg.frame) + 10, SCREEN_WIDTH, 20)];
    [_scView addSubview:rechargeTreatyLabel];
    rechargeTreatyLabel.textAlignment = NSTextAlignmentCenter;
    rechargeTreatyLabel.font = [UIFont systemFontOfSize:12];
    rechargeTreatyLabel.textColor = [ResourceManager color_1];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                          initWithString:@"点击立即支付，即表示已阅读并同意充值活动协议"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xD8B576) range:NSMakeRange(attrStr.length - 6, 6)];
    rechargeTreatyLabel.attributedText = attrStr;
    
    UIButton *treatyBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 60, CGRectGetMinY(rechargeTreatyLabel.frame), 80, 20)];
    [_scView addSubview:treatyBtn];
    [treatyBtn addTarget:self action:@selector(treaty) forControlEvents:UIControlEventTouchUpInside];
    
    _scView.contentSize = CGSizeMake(0, CGRectGetMaxY(rechargeTreatyLabel.frame) + 20);
}

//查看协议
-(void)treaty{
    
}

//选择额度
-(void)amountTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    ((UIButton *)_amountBtnArr[2]).selected = NO;
    if (sender != _amountBtn) {
        _amountBtn.selected = NO;
        _amountBtn = sender;
    }
    _amountBtn.selected = YES;
    NSArray *rechargeNumArr = @[@(100),@(200),@(500),@(1000)];
     _rechargeAmount = [rechargeNumArr[sender.tag] intValue];
    NSLog(@"%ld-----",_rechargeAmount);
}

//选择支付方式
-(void)payTypeTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender.tag == 0) {
        _zfbPayBtn.selected = YES;
        _wxPayBtn.selected = NO;
    }else{
        _zfbPayBtn.selected = NO;
        _wxPayBtn.selected = YES;
    }
}

#pragma mark --- 充值
-(void)recharge{
    if (_zfbPayBtn.selected) {
        //支付宝支付
        
    }else{
        //微信支付
        
    }
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

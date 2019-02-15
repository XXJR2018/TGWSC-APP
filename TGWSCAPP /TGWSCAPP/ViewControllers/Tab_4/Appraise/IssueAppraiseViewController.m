//
//  IssueAppraiseViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/14.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "IssueAppraiseViewController.h"

#import "AppraiseSuccessViewController.h"
#import "XHStarRateView.h"

@interface IssueAppraiseViewController ()<UITextViewDelegate>
{
    UITextView *_textView;
    UIView *_updataView;
    NSMutableArray *_updataImgArr;
    
    
    UIButton *_anonymityBtn;
}
@property(nonatomic, strong) UILabel *msxfStateLabel;

@property(nonatomic, strong) UILabel *wlfwStateLabel;

@property(nonatomic, strong) UILabel *fwtdStateLabel;

@property(nonatomic, assign) NSInteger msxfStar;

@property(nonatomic, assign) NSInteger wlfwStar;

@property(nonatomic, assign) NSInteger fwtdStar;

@end

@implementation IssueAppraiseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发布评论"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发布评论"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomNavigationBarView *naviView = [self layoutNaviBarViewWithTitle:@"评论"];
    UIButton *issueBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60,NavHeight - 35, 60, 35)];
    [naviView addSubview:issueBtn];
    [issueBtn setTitle:@"发布" forState:UIControlStateNormal];
    issueBtn .titleLabel.font = [UIFont systemFontOfSize:14];
    [issueBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [issueBtn addTarget:self action:@selector(IssueAppraise) forControlEvents:UIControlEventTouchUpInside];
    _updataImgArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
}

#pragma mark ---  发布评论
-(void)IssueAppraise{
    AppraiseSuccessViewController *ctl = [[AppraiseSuccessViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)layoutUI{
    
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:14];
    UIFont *font_2 = [UIFont systemFontOfSize:13];
    
    UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, NavHeight + 10, 45, 45)];
    [self.view addSubview:iconImgView];
    [iconImgView sd_setImageWithURL:[NSURL URLWithString:self.goodsUrl]];
    
    UILabel *msxfLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImgView.frame) + 10, CGRectGetMidY(iconImgView.frame) - 10, 65, 20)];
    [self.view addSubview:msxfLabel];
    msxfLabel.font = font_1;
    msxfLabel.textColor = color_1;
    msxfLabel.text = @"描述相符";
    
    XHStarRateView *msStarRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(msxfLabel.frame), CGRectGetMidY(iconImgView.frame) - 8, 140, 16) finish:^(CGFloat currentScore) {
        self.msxfStar = (NSInteger)currentScore;
        NSArray *starArr = @[@"非常差",@"差",@"一般",@"好",@"非常好"];
        self.msxfStateLabel.text = starArr[self.msxfStar - 1];
    }];
    [self.view addSubview:msStarRateView];
    
    _msxfStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(msStarRateView.frame) + 15, CGRectGetMidY(iconImgView.frame) - 10, 65, 20)];
    [self.view addSubview:_msxfStateLabel];
    _msxfStateLabel.font = font_1;
    _msxfStateLabel.textColor = color_2;
 
    UIView *lineView_1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImgView.frame) + 10, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView_1];
    lineView_1.backgroundColor = [ResourceManager color_5];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView_1.frame) + 10, SCREEN_WIDTH - 20, 120)];
    [self.view addSubview:_textView];
    _textView.delegate = self;
    _textView.font = font_2;
    _textView.textColor = color_2;
    _textView.text = @"宝贝满足你的期许吗？说说它的优点和美中不足的地方吧...评论超10个字可送10积分，上传图片可再送5积分哦~";
    
    CGFloat imgWidth = (SCREEN_WIDTH - 10 * 6)/5;
    
    _updataView =  [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame) + 10, SCREEN_WIDTH, imgWidth)];
    [self.view addSubview:_updataView];
    _updataView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 1; i++) {
        UIImageView *updataImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, imgWidth, imgWidth)];
        [_updataView addSubview:updataImgView];
        updataImgView.layer.borderWidth = 0.5;
        updataImgView.layer.borderColor = [ResourceManager color_5].CGColor;
        updataImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *updataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateImg)];
        updataTap.numberOfTapsRequired = 1;
        [updataImgView addGestureRecognizer:updataTap];
        
        UIImageView *cameraImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(updataImgView.frame) - 10 - 23/2, CGRectGetMidY(updataImgView.frame) - 16/2 - 8, 23, 16)];
        [updataImgView addSubview:cameraImgView];
        cameraImgView.image = [UIImage imageNamed:@"Tab_4-38"];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cameraImgView.frame) +5, imgWidth, 20)];
        [updataImgView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = color_2;
        titleLabel.text = @"添加图片";
    }
    
    UIView *lineView_2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_updataView.frame) + 20, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView_2];
    lineView_2.backgroundColor = [ResourceManager color_5];
    
    _anonymityBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView_2.frame) + (45 - 17)/2, 17, 17)];
    [self.view addSubview:_anonymityBtn];
    [_anonymityBtn setImage:[UIImage imageNamed:@"Tab_4-28"] forState:UIControlStateNormal];
    [_anonymityBtn setImage:[UIImage imageNamed:@"Tab_4-29"] forState:UIControlStateSelected];
    [_anonymityBtn addTarget:self action:@selector(anonymity:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *anonymityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_anonymityBtn.frame) + 8, CGRectGetMaxY(lineView_2.frame), 200, 45)];
    [self.view addSubview:anonymityLabel];
    anonymityLabel.font = font_1;
    anonymityLabel.textColor = color_1;
    anonymityLabel.text = @"匿名";
    
    UILabel *anonymityTSLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 210, CGRectGetMaxY(lineView_2.frame), 200, 45)];
    [self.view addSubview:anonymityTSLabel];
    anonymityTSLabel.font = [UIFont systemFontOfSize:12];
    anonymityTSLabel.textAlignment = NSTextAlignmentRight;
    anonymityTSLabel.textColor = color_2;
    anonymityTSLabel.text = @"你的评价能帮助其他小伙伴呦~";
    
    UIView *lineView_3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(anonymityLabel.frame), SCREEN_WIDTH, 10)];
    [self.view addSubview:lineView_3];
    lineView_3.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UILabel *wlfwLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView_3.frame) + 25, 65, 20)];
    [self.view addSubview:wlfwLabel];
    wlfwLabel.font = font_1;
    wlfwLabel.textColor = color_1;
    wlfwLabel.text = @"物流服务";
    
    XHStarRateView *wlStarRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wlfwLabel.frame), CGRectGetMidY(wlfwLabel.frame) - 8, 140, 16) finish:^(CGFloat currentScore) {
        self.wlfwStar = (NSInteger)currentScore;
        NSArray *starArr = @[@"非常差",@"差",@"一般",@"好",@"非常好"];
        self.wlfwStateLabel.text = starArr[self.wlfwStar - 1];
    }];
    [self.view addSubview:wlStarRateView];
    
    _wlfwStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wlStarRateView.frame) + 15, CGRectGetMidY(wlfwLabel.frame) - 10, 65, 20)];
    [self.view addSubview:_wlfwStateLabel];
    _wlfwStateLabel.font = font_1;
    _wlfwStateLabel.textColor = color_2;
    
    UILabel *fwtdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(wlfwLabel.frame) + 25, 65, 20)];
    [self.view addSubview:fwtdLabel];
    fwtdLabel.font = font_1;
    fwtdLabel.textColor = color_1;
    fwtdLabel.text = @"服务态度";
    
    XHStarRateView *fwStarRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fwtdLabel.frame), CGRectGetMidY(fwtdLabel.frame) - 8, 140, 16) finish:^(CGFloat currentScore) {
        self.fwtdStar = (NSInteger)currentScore;
        NSArray *starArr = @[@"非常差",@"差",@"一般",@"好",@"非常好"];
        self.fwtdStateLabel.text = starArr[self.fwtdStar - 1];
    }];
    [self.view addSubview:fwStarRateView];
    
    _fwtdStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fwStarRateView.frame) + 15, CGRectGetMidY(fwtdLabel.frame) - 10, 65, 20)];
    [self.view addSubview:_fwtdStateLabel];
    _fwtdStateLabel.font = font_1;
    _fwtdStateLabel.textColor = color_2;
}

//匿名
-(void)anonymity:(UIButton *)sender{
    sender.selected = !sender.selected;
}

#pragma  mark-- 改变上传图片控件布局
-(void)changeUpdateImgViewUI{
    [_updataView removeAllSubviews];
    
    CGFloat imgWidth = (SCREEN_WIDTH - 10 * 6)/5;
    if (_updataImgArr.count == 0) {
        UIImageView *updataImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, imgWidth, imgWidth)];
        [_updataView addSubview:updataImgView];
        updataImgView.layer.borderWidth = 0.5;
        updataImgView.layer.borderColor = [ResourceManager color_5].CGColor;
        updataImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *updataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateImg)];
        updataTap.numberOfTapsRequired = 1;
        [updataImgView addGestureRecognizer:updataTap];
        
        UIImageView *cameraImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(updataImgView.frame) - 10 - 23/2, CGRectGetMidY(updataImgView.frame) - 16/2 - 8, 23, 16)];
        [updataImgView addSubview:cameraImgView];
        cameraImgView.image = [UIImage imageNamed:@"Tab_4-38"];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cameraImgView.frame) +5, imgWidth, 20)];
        [updataImgView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [ResourceManager color_6];
        titleLabel.text = @"添加图片";
    }else{
        NSInteger count = 0;
        if (_updataImgArr.count < 5) {
            count = _updataImgArr.count + 1;
        }else{
            count = 5;
        }
        for (int i = 0; i < count; i++) {
            UIImageView *updataImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (imgWidth + 10) * i, 0, imgWidth, imgWidth)];
            [_updataView addSubview:updataImgView];
            updataImgView.layer.borderWidth = 0.5;
            updataImgView.layer.borderColor = [ResourceManager color_5].CGColor;
            if (_updataImgArr.count == 5) {
                [updataImgView sd_setImageWithURL:[NSURL URLWithString:_updataImgArr[i]]];
                UIButton *deleteImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(updataImgView.frame) - 15, -15, 30, 30)];
                [_updataView addSubview:deleteImgBtn];
                deleteImgBtn.tag = i;
                [deleteImgBtn setImage:[UIImage imageNamed:@"Tab_4-39"] forState:UIControlStateNormal];
                [deleteImgBtn addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                if (i < _updataImgArr.count) {
                    [updataImgView sd_setImageWithURL:[NSURL URLWithString:_updataImgArr[i]]];
                    UIButton *deleteImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(updataImgView.frame) - 15, -15, 30, 30)];
                    [_updataView addSubview:deleteImgBtn];
                    deleteImgBtn.tag = i;
                    [deleteImgBtn setImage:[UIImage imageNamed:@"Tab_4-39"] forState:UIControlStateNormal];
                    [deleteImgBtn addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else if (i == _updataImgArr.count) {
                    updataImgView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *updataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateImg)];
                    updataTap.numberOfTapsRequired = 1;
                    [updataImgView addGestureRecognizer:updataTap];
                    
                    UIImageView *cameraImgView = [[UIImageView alloc]initWithFrame:CGRectMake((imgWidth - 23)/2, CGRectGetMidY(updataImgView.frame) - 16/2 - 8, 23, 16)];
                    [updataImgView addSubview:cameraImgView];
                    cameraImgView.image = [UIImage imageNamed:@"Tab_4-38"];
                    
                    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cameraImgView.frame) +5, imgWidth, 20)];
                    [updataImgView addSubview:titleLabel];
                    titleLabel.font = [UIFont systemFontOfSize:11];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.textColor = [ResourceManager color_6];
                    if (i == 1) {
                        titleLabel.text = @"1/5";
                    }else if (i == 2) {
                        titleLabel.text = @"2/5";
                    }else if (i == 3) {
                        titleLabel.text = @"3/5";
                    }else if (i == 4) {
                        titleLabel.text = @"4/5";
                    }
                }
            }
            
        }
    }
    
}

#pragma  mark-- 上传图片
-(void)updateImg{
    [_updataImgArr addObject:@"https://static.xxjr.com/tgmall/goods/2018-12-29/602f7604-47a1-47a8-9bb3-6504cd1684f5.jpg"];
    [self changeUpdateImgViewUI];
}

-(void)deleteImg:(UIButton *)sender {
    [_updataImgArr removeObject:@"https://static.xxjr.com/tgmall/goods/2018-12-29/602f7604-47a1-47a8-9bb3-6504cd1684f5.jpg"];
    [self changeUpdateImgViewUI];
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

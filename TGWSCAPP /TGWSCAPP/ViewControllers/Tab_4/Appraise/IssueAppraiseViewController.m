//
//  IssueAppraiseViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/14.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "IssueAppraiseViewController.h"

#import "XHStarRateView.h"

@interface IssueAppraiseViewController ()<UITextViewDelegate>
{
    UITextView *_textView;
}
@property(nonatomic, strong) UILabel *msxfStateLabel;

@property(nonatomic, assign) NSInteger msxfStar;

@property(nonatomic, assign) NSInteger wlfwfStar;

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
    
    [self layoutNaviBarViewWithTitle:@"评论"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
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
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView_1.frame) + 10, SCREEN_WIDTH - 20, 150)];
    [self.view addSubview:_textView];
    _textView.delegate = self;
    _textView.font = font_2;
    _textView.textColor = color_2;
    _textView.text = @"宝贝满足你的期许吗？说说它的优点和美中不足的地方吧...评论超10个字可送10积分，上传图片可再送5积分哦~";
    
//    UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, NavHeight + 10, 45, 45)];
//    [self.view addSubview:iconImgView];
//    [iconImgView sd_setImageWithURL:[NSURL URLWithString:self.goodsUrl]];
    
    
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

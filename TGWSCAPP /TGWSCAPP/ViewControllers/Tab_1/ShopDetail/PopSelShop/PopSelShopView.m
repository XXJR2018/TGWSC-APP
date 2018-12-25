//
//  PopSelShopView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "PopSelShopView.h"

@interface PopSelShopView ()
{
}

@property (nonatomic, weak) UIWindow *keyWindow; ///< 当前窗口
@property (nonatomic, strong) UIView *tailView;  // 底部的弹出View
@property (nonatomic, strong) UIView *shadeView; ///< 遮罩层
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; ///< 点击背景阴影的手

@property (nonatomic, assign) CGFloat windowWidth; ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; ///< 窗口高度

@end

@implementation PopSelShopView



#pragma mark - Lift Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self drawUI];
}


#pragma mark - Private
/*! @brief 初始化相关 */
- (void)initialize {

    // current view
    self.backgroundColor = [UIColor whiteColor];
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    //[self setShowShade:NO];
    
    // tailview
    _tailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _windowWidth, _windowHeight*2/3)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;

    [self addSubview:_tailView];
}


-(void) drawUI
{
    NSLog(@"self.shopModel:%@",self.shopModel);
    NSLog(@"self.arrSku:%@",self.arrSku);
    
    int iLeftX = 15;
    int iTopY = 20;
    int iIMGWdith = 120 *ScaleSize;
    UIImageView *imgShop = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iIMGWdith, iIMGWdith)];
    [_tailView addSubview:imgShop];
    imgShop.backgroundColor = [UIColor yellowColor];
    [imgShop setImageWithURL:[NSURL URLWithString:_shopModel.strGoodsImgUrl]];
    
    iLeftX += imgShop.width + 10;
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, 20)];
    [_tailView addSubview:labelName];
    labelName.font = [UIFont systemFontOfSize:14];
    labelName.textColor = [ResourceManager color_1];
    labelName.text = self.shopModel.strGoodsSubName;
    
    
}

#pragma mark - Public

/*! @brief 指向指定的View来显示弹窗 */
- (void)show {

    // 遮罩层
    _shadeView.backgroundColor = [UIColor blackColor];
    _shadeView.alpha = 0.4f;
    [_keyWindow addSubview:_shadeView];

    CGFloat currentH = _tailView.height;
    self.frame = CGRectMake(0, _windowHeight, _windowWidth, currentH);
    [_keyWindow addSubview:self];
    
    //弹出动画
    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // 从底部弹出
        self.frame = CGRectMake(0, self.windowHeight - currentH, self.windowWidth, currentH);
        
        // 从顶部弹出
        //self.frame = CGRectMake(0, 0, self.windowWidth, currentH);
    } completion:^(BOOL finished) {
        
    }];
}


-(void) hide {
    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        // 从底部消失
        self.frame = CGRectMake(0, self.windowHeight, self.windowWidth, self.tailView.height);
        
        // 从顶部消失
        //self.frame = CGRectMake(0, -self.windowHeight, self.windowWidth, self.tailView.height);
        
    } completion:^(BOOL finished) {
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
@end

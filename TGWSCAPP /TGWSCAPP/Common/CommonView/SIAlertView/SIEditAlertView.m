//
//  SIEditAlertView.m
//  SIAlertViewExample
//
//  Created by xxjr02 on 16/8/12.
//  Copyright © 2016年 Sumi Interactive. All rights reserved.
//

#import "SIEditAlertView.h"


#define TextViewHeight 55.0
#define TextFieldHeight 25.0
#define StarsViewHeight 18.0
#define Gray_Bg_Color [UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0]

@class SIAlertBackgroundWindow;

static NSMutableArray *__si_alert_queue;
static BOOL __si_alert_animating;
static SIAlertBackgroundWindow *__si_alert_background_window;
static SIEditAlertView *__si_alert_current_view;

@interface SIEditAlertView ()<UITextViewDelegate,UITextFieldDelegate,CAAnimationDelegate>

@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, assign, getter = isVisible) BOOL visible;
@property (nonatomic, assign, getter = isKeyboardShowed) BOOL keyboardShowed;


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) DPMeterView *meterView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, assign, getter = isLayoutDirty) BOOL layoutDirty;

+ (NSMutableArray *)sharedQueue;
+ (SIEditAlertView *)currentAlertView;

+ (BOOL)isAnimating;
+ (void)setAnimating:(BOOL)animating;

+ (void)showBackground;
+ (void)hideBackgroundAnimated:(BOOL)animated;

- (void)setup;
- (void)invaliadateLayout;
- (void)resetTransition;

@end

#pragma mark - SIBackgroundWindow

#pragma mark - SIEditAlertItem

@interface SIEditAlertItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SIAlertViewButtonType type;
@property (nonatomic, copy) SIEditAlertViewHandler action;

@end

@implementation SIEditAlertItem

@end

#pragma mark - SIAlertViewController


#pragma mark - SIEditAlertView

@implementation SIEditAlertView

@synthesize showFieldEditView = _showFieldEditView;

+ (void)initialize
{
    if (self != [SIAlertView class])
        return;
    
    SIAlertView *appearance = [self appearance];
    appearance.viewBackgroundColor = [UIColor whiteColor];
    appearance.titleColor = [UIColor blackColor];
    appearance.messageColor = [UIColor darkGrayColor];
    appearance.titleFont =  [UIFont systemFontOfSize:15.0]; // [UIFont boldSystemFontOfSize:16];
    appearance.messageFont = [UIFont systemFontOfSize:13];
    appearance.buttonFont = [UIFont systemFontOfSize:14];
    appearance.cornerRadius = 2;
    appearance.shadowRadius = 8;
}

- (id)init
{
    return [self initWithTitle:nil andMessage:nil];
}

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        _title = title;
        _message = message;
        _showFieldEditView = NO;
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Class methods

+ (NSMutableArray *)sharedQueue
{
    if (!__si_alert_queue) {
        __si_alert_queue = [NSMutableArray array];
    }
    return __si_alert_queue;
}

+ (SIEditAlertView *)currentAlertView
{
    return __si_alert_current_view;
}

+ (void)setCurrentAlertView:(SIEditAlertView *)alertView
{
    __si_alert_current_view = alertView;
}

+ (BOOL)isAnimating
{
    return __si_alert_animating;
}

+ (void)setAnimating:(BOOL)animating
{
    __si_alert_animating = animating;
}

+ (void)showBackground
{
    if (!__si_alert_background_window) {
        __si_alert_background_window = [[SIAlertBackgroundWindow alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                                             andStyle:[SIEditAlertView currentAlertView].backgroundStyle];
        [__si_alert_background_window makeKeyAndVisible];
        __si_alert_background_window.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             __si_alert_background_window.alpha = 1;
                         }];
    }
}

+ (void)hideBackgroundAnimated:(BOOL)animated
{
    if (!animated) {
        [__si_alert_background_window removeFromSuperview];
        __si_alert_background_window = nil;
        return;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         __si_alert_background_window.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [__si_alert_background_window removeFromSuperview];
                         __si_alert_background_window = nil;
                     }];
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self invaliadateLayout];
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    [self invaliadateLayout];
}


#pragma mark - Public

- (void)addButtonWithTitle:(NSString *)title type:(SIAlertViewButtonType)type handler:(SIEditAlertViewHandler)handler
{
    SIEditAlertItem *item = [[SIEditAlertItem alloc] init];
    item.title = title;
    item.type = type;
    item.action = handler;
    [self.items addObject:item];
}

- (void)show
{
    if (![[SIEditAlertView sharedQueue] containsObject:self]) {
        [[SIEditAlertView sharedQueue] addObject:self];
    }
    
    if ([SIEditAlertView isAnimating]) {
        return; // wait for next turn
    }
    
    if (self.isVisible) {
        return;
    }
    
    if ([SIEditAlertView currentAlertView].isVisible) {
        SIEditAlertView *alert = [SIEditAlertView currentAlertView];
        [alert dismissAnimated:YES cleanup:NO];
        return;
    }
    
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SIAlertViewWillShowNotification object:self userInfo:nil];
    
    self.visible = YES;
    
    [SIEditAlertView setAnimating:YES];
    [SIEditAlertView setCurrentAlertView:self];
    
    // transition background
    [SIEditAlertView showBackground];
    
    SIAlertViewController *viewController = [[SIAlertViewController alloc] initWithNibName:nil bundle:nil];
    viewController.alertView = self;
    
    if (!self.alertWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = 1999.0;
        window.rootViewController = viewController;
        self.alertWindow = window;
    }
    [self.alertWindow makeKeyAndVisible];
    
    [self validateLayout];
    
    [self transitionInCompletion:^{
        if (self.didShowHandler) {
            self.didShowHandler(self);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SIAlertViewDidShowNotification object:self userInfo:nil];
        
        // 添加点击消失的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
        [viewController.view addGestureRecognizer:tap];
        
        [SIEditAlertView setAnimating:NO];
        
        NSInteger index = [[SIEditAlertView sharedQueue] indexOfObject:self];
        if (index < [SIEditAlertView sharedQueue].count - 1) {
            [self dismissAnimated:YES cleanup:NO]; // dismiss to show next alert view
        }
    }];
}

-(void)endEdit{
    [self.fieldView1 resignFirstResponder];
    [self.fieldView2 resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (void)dismissAnimated:(BOOL)animated
{
    [self dismissAnimated:animated cleanup:YES];
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup
{
    BOOL isVisible = self.isVisible;
    
    if (isVisible) {
        if (self.willDismissHandler) {
            self.willDismissHandler(self);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SIAlertViewWillDismissNotification object:self userInfo:nil];
    }
    
    void (^dismissComplete)(void) = ^{
        self.visible = NO;
        
        [self teardown];
        
        [SIEditAlertView setCurrentAlertView:nil];
        
        SIEditAlertView *nextAlertView;
        NSInteger index = [[SIEditAlertView sharedQueue] indexOfObject:self];
        if (index != NSNotFound && index < [SIEditAlertView  sharedQueue].count - 1) {
            nextAlertView = [SIEditAlertView sharedQueue][index + 1];
        }
        
        if (cleanup) {
            [[SIEditAlertView sharedQueue] removeObject:self];
        }
        
        [SIEditAlertView setAnimating:NO];
        
        if (isVisible) {
            if (self.didDismissHandler) {
                self.didDismissHandler(self);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:SIAlertViewDidDismissNotification object:self userInfo:nil];
        }
        
        // check if we should show next alert
        if (!isVisible) {
            return;
        }
        
        if (nextAlertView) {
            [nextAlertView show];
        } else {
            // show last alert view
            if ([SIEditAlertView sharedQueue].count > 0) {
                SIEditAlertView *alert = [[SIEditAlertView sharedQueue] lastObject];
                [alert show];
            }
        }
    };
    
    if (animated && isVisible) {
        [SIEditAlertView setAnimating:YES];
        [self transitionOutCompletion:dismissComplete];
        
        if ([SIEditAlertView sharedQueue].count == 1) {
            [SIEditAlertView hideBackgroundAnimated:YES];
        }
        
    } else {
        dismissComplete();
        
        if ([SIEditAlertView sharedQueue].count == 0) {
            [SIEditAlertView hideBackgroundAnimated:YES];
        }
    }
}

#pragma mark - Transitions

- (void)transitionInCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case SIAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleFade:
        {
            self.containerView.alpha = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bouce"];
        }
            break;
        case SIAlertViewTransitionStyleDropDown:
        {
            CGFloat y = self.containerView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"dropdown"];
        }
            break;
        default:
            break;
    }
}

- (void)transitionOutCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case SIAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleFade:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.containerView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
            
            self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
            break;
        case SIAlertViewTransitionStyleDropDown:
        {
            CGPoint point = self.containerView.center;
            point.y += self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 self.containerView.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}

- (void)resetTransition
{
    [self.containerView.layer removeAllAnimations];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self validateLayout];
}

- (void)invaliadateLayout
{
    self.layoutDirty = YES;
    [self setNeedsLayout];
}

- (void)validateLayout
{
    if (!self.isLayoutDirty) {
        return;
    }
    self.layoutDirty = NO;
#if DEBUG_LAYOUT
    NSLog(@"%@, %@", self, NSStringFromSelector(_cmd));
#endif
    
    CGFloat height = [self preferredHeight];
    CGFloat left = (self.bounds.size.width - CONTAINER_WIDTH) * 0.5;
    CGFloat top = (self.bounds.size.height - height) * 0.5;
    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.frame = CGRectMake(left, top, CONTAINER_WIDTH, height);
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
    
    CGFloat y = CONTENT_PADDING_TOP;
    if (self.titleLabel) {
        self.titleLabel.text = self.title;
        CGFloat height = [self heightForTitleLabel];
        self.titleLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
    }
    
    if (self.messageLabel) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        self.messageLabel.text = self.message;
        CGFloat height = [self heightForMessageLabel];
        self.messageLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
    }
    
    if (self.stars) {
        CGFloat height = StarsViewHeight;
        self.meterView.frame = CGRectMake(CONTENT_PADDING_LEFT, y+5, 100.0, height);
        y += height + 2.0;
        self.meterView.meterType = DPMeterTypeLinearHorizontal;
        [self.meterView setShape:[UIBezierPath stars:5 shapeInFrame:self.meterView.frame].CGPath];
    }
    
    if (self.showFieldEditView) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        
        float fieldWidth = (self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2)/2 - 5;
        self.fieldView1.frame = CGRectMake(CONTENT_PADDING_LEFT, y, fieldWidth, TextFieldHeight);
        
        self.fieldView2.frame = CGRectMake((self.containerView.bounds.size.width - CONTENT_PADDING_LEFT) - fieldWidth, y, fieldWidth, TextFieldHeight);
        
        y += TextFieldHeight;
    }
    
    // TextView 的高度
    {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        self.textView.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, TextViewHeight);
        
        y += TextViewHeight;
    }
    
    if (self.items.count > 0) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP + 5.0;
        }
        if (self.items.count == 2) {
            CGFloat width = (self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2 - GAP) * 0.5;
            UIButton *button = self.buttons[0];
            button.frame = CGRectMake(CONTENT_PADDING_LEFT - 3, y, width, BUTTON_HEIGHT);
            button = self.buttons[1];
            button.frame = CGRectMake(CONTENT_PADDING_LEFT + width + GAP + 3, y, width, BUTTON_HEIGHT);
        } else {
            for (NSUInteger i = 0; i < self.buttons.count; i++) {
                UIButton *button = self.buttons[i];
                button.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, BUTTON_HEIGHT);
                if (self.buttons.count > 1) {
                    if (i == self.buttons.count - 1 && ((SIEditAlertItem *)self.items[i]).type == SIAlertViewButtonTypeCancel) {
                        CGRect rect = button.frame;
                        rect.origin.y += CANCEL_BUTTON_PADDING_TOP;
                        button.frame = rect;
                    }
                    y += BUTTON_HEIGHT + GAP;
                }
            }
        }
    }
}

- (CGFloat)preferredHeight
{
    CGFloat height = CONTENT_PADDING_TOP;
    if (self.title) {
        height += [self heightForTitleLabel];
    }
    if (self.message) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        height += [self heightForMessageLabel];
    }
    
    if (self.stars) {
        height += StarsViewHeight + GAP;
    }
    
    if (self.showFieldEditView) {
        height += TextFieldHeight + GAP;
    }
    
    {
        height += TextViewHeight + GAP;
    }
    
    if (self.items.count > 0) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        if (self.items.count <= 2) {
            height += BUTTON_HEIGHT;
        } else {
            height += (BUTTON_HEIGHT + GAP) * self.items.count - GAP;
            if (self.buttons.count > 2 && ((SIEditAlertItem *)[self.items lastObject]).type == SIAlertViewButtonTypeCancel) {
                height += CANCEL_BUTTON_PADDING_TOP;
            }
        }
        
    
    }
    height += CONTENT_PADDING_BOTTOM;
    return height;
}

- (CGFloat)heightForTitleLabel
{
    if (self.titleLabel) {
        CGSize size = [self.title boundingRectWithSize:CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, 200.0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
        
        return size.height;
    }
    return 0;
}

- (CGFloat)heightForMessageLabel
{
    CGFloat minHeight = MESSAGE_MIN_LINE_COUNT * self.messageLabel.font.lineHeight;
    if (self.messageLabel) {
        CGFloat maxHeight = MESSAGE_MAX_LINE_COUNT * self.messageLabel.font.lineHeight;
        
        CGSize size = [self.message boundingRectWithSize:CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.messageLabel.font} context:nil].size;
        
        return MAX(minHeight, size.height);
    }
    return minHeight;
}

#pragma mark - Setup

- (void)setup
{
    [self setupContainerView];
    [self updateTitleLabel];
    [self updateMessageLabel];
    [self updateStarsView];
    [self setupTextFieldViews];
    [self setupButtons];
    [self invaliadateLayout];
}

- (void)teardown
{
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    self.titleLabel = nil;
    self.messageLabel = nil;
    self.meterView = nil;
    [self.buttons removeAllObjects];
    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)setupContainerView
{
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = self.cornerRadius;
    self.containerView.layer.shadowOffset = CGSizeZero;
    self.containerView.layer.shadowRadius = self.shadowRadius;
    self.containerView.layer.shadowOpacity = 0.2;
    [self addSubview:self.containerView];
}

- (void)updateTitleLabel
{
    if (self.title) {
        if (!self.titleLabel) {
            self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.font = self.titleFont;
            self.titleLabel.textColor = self.titleColor;
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
            self.titleLabel.minimumScaleFactor = self.titleLabel.font.pointSize * 0.75;
            [self.containerView addSubview:self.titleLabel];
#if DEBUG_LAYOUT
            self.titleLabel.backgroundColor = [UIColor redColor];
#endif
        }
        self.titleLabel.text = self.title;
    } else {
        [self.titleLabel removeFromSuperview];
        self.titleLabel = nil;
    }
    [self invaliadateLayout];
}

- (void)updateMessageLabel
{
    if (self.message) {
        if (!self.messageLabel) {
            self.messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.backgroundColor = [UIColor clearColor];
            self.messageLabel.font = self.messageFont;
            self.messageLabel.textColor = self.messageColor;
            self.messageLabel.numberOfLines = MESSAGE_MAX_LINE_COUNT;
            [self.containerView addSubview:self.messageLabel];
#if DEBUG_LAYOUT
            self.messageLabel.backgroundColor = [UIColor redColor];
#endif
        }
        self.messageLabel.text = self.message;
    } else {
        [self.messageLabel removeFromSuperview];
        self.messageLabel = nil;
    }
    [self invaliadateLayout];
}

- (void)updateStarsView
{
    if (self.stars) {
        if (!self.meterView) {
            self.meterView = [[DPMeterView alloc] initWithFrame:self.bounds];
            self.meterView.enable = YES;
            self.meterView.tapBlock = ^(int starCount){
                _starCount = starCount;
            };
            [self.containerView addSubview:self.meterView];
#if DEBUG_LAYOUT
            self.meterView.backgroundColor = [UIColor redColor];
#endif
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.titleLabel.textColor = [ResourceManager CellTitleColor];
        }
        
//        [self.meterView add:1.0 animated:NO];
//        self.meterView.meterType = DPMeterTypeLinearHorizontal;
//        [self.meterView setShape:[UIBezierPath stars:4 shapeInFrame:self.meterView.frame].CGPath];
    } else {
        [self.meterView removeFromSuperview];
        self.meterView = nil;
    }
    [self invaliadateLayout];
}

- (void)setupTextFieldViews{
    if (!self.textView) {
        self.textView = [[UITextView alloc] init];
        self.textView.textColor = [ResourceManager CellTitleColor];//设置textview里面的字体颜色
        self.textView.font = [UIFont fontWithName:@"Arial" size:13.0];//设置字体名字和字体大小
        self.textView.delegate = self;//设置它的委托方法
        self.textView.backgroundColor = Gray_Bg_Color;//设置它的背景颜色
        self.textView.text = @"描述...";//设置它显示的内容
        
        self.textView.returnKeyType = UIReturnKeyDone;//返回键的类型
        self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
        self.textView.scrollEnabled = YES;//是否可以拖动
        
        [self.containerView addSubview:self.textView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    
    if (self.showFieldEditView) {
        UIFont *font = [UIFont systemFontOfSize:14.0];
        
        _fieldView1 = [[UITextField alloc] init];
        _fieldView2 = [[UITextField alloc] init];
        _fieldView1.delegate = _fieldView2.delegate = self;
        _fieldView1.keyboardType = _fieldView2.keyboardType = UIKeyboardTypeNumberPad;
        _fieldView1.returnKeyType = _fieldView2.returnKeyType = UIReturnKeyDone;
        _fieldView1.rightViewMode = _fieldView2.rightViewMode = UITextFieldViewModeAlways;
//        _fieldView1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _fieldView1.font = _fieldView2.font = font;
        _fieldView1.textColor = _fieldView2.textColor = [ResourceManager redColor2];
        _fieldView1.textAlignment = _fieldView2.textAlignment = NSTextAlignmentCenter;
//        _fieldView1.layer.borderWidth = _fieldView2.layer.borderWidth = 1.0;
//        _fieldView1.layer.borderColor = _fieldView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _fieldView1.backgroundColor = _fieldView2.backgroundColor = Gray_Bg_Color;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:label1.bounds];
        label1.textColor = label2.textColor = label1.textColor = [UIColor grayColor];
        label1.text = @"万元";   label2.text = @"个月";
        label1.font = label2.font = _fieldView1.font;
        
        _fieldView1.rightView = label1;
        _fieldView2.rightView = label2;
        
        [self.containerView addSubview:_fieldView1];
        [self.containerView addSubview:_fieldView2];
    }else{
        [_fieldView1 removeFromSuperview];
        _fieldView1 = nil;
        
        [_fieldView2 removeFromSuperview];
        _fieldView2 = nil;
    }
    
    [self invaliadateLayout];
}

- (void)setupButtons
{
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    for (NSUInteger i = 0; i < self.items.count; i++) {
        UIButton *button = [self buttonForItemIndex:i];
        [self.buttons addObject:button];
        [self.containerView addSubview:button];
    }
}

- (UIButton *)buttonForItemIndex:(NSUInteger)index
{
    SIEditAlertItem *item = self.items[index];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.titleLabel.font = self.buttonFont;
    [button setTitle:item.title forState:UIControlStateNormal];
    UIImage *normalImage = nil;
    UIImage *highlightedImage = nil;
    switch (item.type) {
        case SIAlertViewButtonTypeCancel:
            [button setTitleColor:[ResourceManager redColor2] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.3 alpha:0.8] forState:UIControlStateHighlighted];
            break;
        case SIAlertViewButtonTypeDestructive:
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:UIControlStateHighlighted];
            break;
        case SIAlertViewButtonTypeDefault:
        default:
            [button setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.4 alpha:0.8] forState:UIControlStateHighlighted];
            break;
    }
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    button.backgroundColor = Gray_Bg_Color;
    button.layer.cornerRadius = 4.0;
    
    return button;
}

#pragma mark - Actions

- (void)buttonAction:(UIButton *)button
{
    [SIEditAlertView setAnimating:YES]; // set this flag to YES in order to prevent showing another alert in action block
    SIEditAlertItem *item = self.items[button.tag];
    if (item.action) {
        item.action(self);
    }
    
    if (item.type == SIAlertViewButtonTypeCancel && self.items.count == 2) {
        if (self.textView.text.length <= 0 || [self.textView.text isEqualToString:@"描述..."]) {
            return;
        }else if (self.showFieldEditView && (self.fieldView1.text.length <= 0 || self.fieldView1.text.intValue <= 0)){
            return;
        }else if (self.showFieldEditView && (self.fieldView2.text.length <= 0 || self.fieldView2.text.intValue <= 0)){
            return;
        }
    }
    
    [self dismissAnimated:YES];
}

#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}

#pragma mark - UIAppearance setters

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor
{
    if (_viewBackgroundColor == viewBackgroundColor) {
        return;
    }
    _viewBackgroundColor = viewBackgroundColor;
    self.containerView.backgroundColor = viewBackgroundColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont == titleFont) {
        return;
    }
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
    [self invaliadateLayout];
}

- (void)setMessageFont:(UIFont *)messageFont
{
    if (_messageFont == messageFont) {
        return;
    }
    _messageFont = messageFont;
    self.messageLabel.font = messageFont;
    [self invaliadateLayout];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor == titleColor) {
        return;
    }
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMessageColor:(UIColor *)messageColor
{
    if (_messageColor == messageColor) {
        return;
    }
    _messageColor = messageColor;
    self.messageLabel.textColor = messageColor;
}

- (void)setButtonFont:(UIFont *)buttonFont
{
    if (_buttonFont == buttonFont) {
        return;
    }
    _buttonFont = buttonFont;
    for (UIButton *button in self.buttons) {
        button.titleLabel.font = buttonFont;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    if (_shadowRadius == shadowRadius) {
        return;
    }
    _shadowRadius = shadowRadius;
    self.containerView.layer.shadowRadius = shadowRadius;
}

- (void)setShowFieldEditView:(BOOL)showFieldEditView{
    if ( _showFieldEditView == showFieldEditView) {
        return;
    }
    _showFieldEditView = showFieldEditView;
    [self invaliadateLayout];
}

-(BOOL)showFieldEditView{
    return _showFieldEditView;
}


#pragma mark === UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    // 向上偏移
    
    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)animationUp{
    
}

#pragma mark - notification handler

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    
    if (!self.keyboardShowed) {
        CGRect keyBoardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat deltaY = keyBoardRect.size.height - self.containerView.frame.origin.y/2;
        [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.containerView.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        }];
        
        self.keyboardShowed = YES;
    }
    
}

-(void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    }];
    
    self.keyboardShowed = NO;
}



@end

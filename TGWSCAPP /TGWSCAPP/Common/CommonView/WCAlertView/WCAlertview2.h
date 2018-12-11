//
//  WCAlertview.h
//  WCAlertView
//
//  Created by huangwenchen on 15/2/17.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import <UIKit/UIKit.h>
// 通知的弹窗
@protocol WCALertviewDelegate2<NSObject>
@optional
-(void)didClickButtonAtIndex2:(NSUInteger)index;

@end

@interface WCAlertview2 : UIView
@property (weak,nonatomic) id<WCALertviewDelegate2> delegate;



//  退款提醒
-(instancetype)initWithTitle:(NSString *) title Image:(UIImage *)image CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;


// 普通通知， 点击“查看详情”，跳转url
-(instancetype)initWithTitle:(NSString *) title   Message:(NSString*)message  Image:(UIImage *)image   CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;

- (void)show;

@property (strong,nonatomic)NSString * strVerion;
@property (strong,nonatomic) NSString  *strUrl;
@property (strong,nonatomic) NSString  *strNoteMessage;
@property (strong,nonatomic) UIViewController  *parentVC;
@end

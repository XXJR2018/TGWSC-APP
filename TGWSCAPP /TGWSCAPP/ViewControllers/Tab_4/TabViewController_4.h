//
//  TabViewController_4.h
//  XXJR
//
//  Created by xxjr03 on 2018/12/4.
//  Copyright © 2018 Cary. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabViewController_4 : CommonViewController
/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

@property(nonatomic,strong) UIView *tabBar;

-(void)addButtonView;

@end

NS_ASSUME_NONNULL_END

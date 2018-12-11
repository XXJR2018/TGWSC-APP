//
//  MBProgressHUD+PD.h
//  EVTUtils
//
//  Created by lijian qiu on 12-6-19.
//  Copyright (c) 2012年 Paidui, Inc. All rights reserved.
//

#import <MBProgressHUD.h>

@interface MBProgressHUD (PD)

/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
+ (id)showNoNetworkHUDToView:(UIView *)view;
/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
+ (id)showSuccessWithStatus:(NSString *)string toView:(UIView *)view;
/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
+ (id)showWithStatus:(NSString *)string toView:(UIView *)view;
/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
+ (id)showErrorWithStatus:(NSString *)string toView:(UIView *)view;

/**
 *  仅显示文本信息
 *
 *  @param string 字符串信息
 *  @param view   父view
 *
 *  @return MBProgressHUD对象
 */
+ (id)showOnlyText:(NSString *)string toView:(UIView *)view;

/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
- (void)toShowSuccessWithStatus:(NSString *)string;
/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
- (void)toShowErrorWithStatus:(NSString *)string;
/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
- (void)toShowNoNetwork;

@end

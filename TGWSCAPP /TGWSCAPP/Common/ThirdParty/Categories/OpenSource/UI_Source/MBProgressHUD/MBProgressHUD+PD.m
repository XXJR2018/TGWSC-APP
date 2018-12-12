//
//  MBProgressHUD+PD.m
//  EVTUtils
//
//  Created by lijian qiu on 12-6-19.
//  Copyright (c) 2012年 Paidui, Inc. All rights reserved.
//

#import "MBProgressHUD+PD.h"
#import "LanguageManager.h"

@implementation MBProgressHUD (PD)


+ (id)showHUDAddedTo:(UIView *)view;
{
    [MBProgressHUD hideHUDForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    //6，设置菊花颜色  只能设置菊花的颜色
    hud.activityIndicatorColor = [UIColor whiteColor];
//    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor]; //菊花颜色 全局设置,不起作用

    return hud;
}

+ (id)showNoNetworkHUDToView:(UIView *)view;
{
	[MBProgressHUD hideHUDForView:view animated:NO];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.removeFromSuperViewOnHide = YES;
	hud.label.text = [LanguageManager networkUnreachableTipsString];
    hud.label.numberOfLines = 0;
	hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
    [hud hideAnimated:YES afterDelay:2.0];
	return hud;
}

+ (id)showWithStatus:(NSString *)string toView:(UIView *)view
{
	[MBProgressHUD hideHUDForView:view animated:NO];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.removeFromSuperViewOnHide = YES;
	hud.label.text = string;
    hud.label.numberOfLines = 0;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
	return hud;
}

+ (id)showErrorWithStatus:(NSString *)string toView:(UIView *)view
{
	[MBProgressHUD hideHUDForView:view animated:NO];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeCustomView;
	hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
	hud.label.text = string;
    hud.label.numberOfLines = 0;
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
    [hud hideAnimated:YES afterDelay:2.0];
	return hud;
}

+ (id)showSuccessWithStatus:(NSString *)string toView:(UIView *)view
{
	[MBProgressHUD hideHUDForView:view animated:NO];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeCustomView;
	hud.removeFromSuperViewOnHide = YES;
	hud.label.text = string;
    hud.label.numberOfLines = 0;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
    [hud hideAnimated:YES afterDelay:2.0];
	return hud;
}

+ (id)showOnlyText:(NSString *)string toView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.label.text = string;
    hud.label.numberOfLines = 0;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
	hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
    return hud;
}


- (void)toShowSuccessWithStatus:(NSString *)string
{
    [MBProgressHUD showSuccessWithStatus:string toView:[UIApplication sharedApplication].keyWindow];
}

- (void)toShowErrorWithStatus:(NSString *)string
{
    [MBProgressHUD showErrorWithStatus:string toView:[UIApplication sharedApplication].keyWindow];
}

- (void)toShowNoNetwork
{
    [MBProgressHUD showNoNetworkHUDToView:[UIApplication sharedApplication].keyWindow];
}


@end

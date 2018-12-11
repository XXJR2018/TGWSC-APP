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

+ (id)showNoNetworkHUDToView:(UIView *)view;
{
	[MBProgressHUD hideAllHUDsForView:view animated:NO];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.removeFromSuperViewOnHide = YES;
	hud.labelText = [LanguageManager networkUnreachableTipsString];
	hud.mode = MBProgressHUDModeCustomView;
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
	[hud hide:YES afterDelay:2.0];
	return hud;
}

+ (id)showWithStatus:(NSString *)string toView:(UIView *)view
{
	[MBProgressHUD hideAllHUDsForView:view animated:NO];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.removeFromSuperViewOnHide = YES;
	hud.labelText = string;
	return hud;
}

+ (id)showErrorWithStatus:(NSString *)string toView:(UIView *)view
{
	[MBProgressHUD hideAllHUDsForView:view animated:NO];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeCustomView;
	hud.removeFromSuperViewOnHide = YES;
	hud.labelText = string;
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
	[hud hide:YES afterDelay:2.0];
	return hud;
}

+ (id)showSuccessWithStatus:(NSString *)string toView:(UIView *)view
{
	[MBProgressHUD hideAllHUDsForView:view animated:NO];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeCustomView;
	hud.removeFromSuperViewOnHide = YES;
	hud.labelText = string;
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
	[hud hide:YES afterDelay:2.0];
	return hud;
}

+ (id)showOnlyText:(NSString *)string toView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
	hud.mode = MBProgressHUDModeText;
	hud.labelText = string;
	hud.margin = 10.f;
	hud.yOffset = 0.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:2.0f];
    
    return hud;
}


- (void)toShowSuccessWithStatus:(NSString *)string
{
	self.mode = MBProgressHUDModeCustomView;
	self.labelText = string;
	self.removeFromSuperViewOnHide = YES;
	self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
	[self hide:YES afterDelay:2.0];
}

- (void)toShowErrorWithStatus:(NSString *)string
{
    if ([string isKindOfClass:[NSString class]])
    {
        self.mode = MBProgressHUDModeCustomView;
        self.labelText = string;
        self.removeFromSuperViewOnHide = YES;
        self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
        
    }
    [self hide:YES afterDelay:2.0];
	
}

- (void)toShowNoNetwork
{
	self.labelText = [LanguageManager networkUnreachableTipsString];
	self.mode = MBProgressHUDModeCustomView;
	self.removeFromSuperViewOnHide = YES;
	self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
	[self hide:YES afterDelay:2.0];
}


@end

//
//  ShopModel.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopModel : NSObject

@property (nonatomic,assign) int   iShopID;
@property (nonatomic,copy) NSString *strShopID;
@property (nonatomic,copy) NSString *strShopName;
@property (nonatomic,copy) NSString *strShopImgUrl;
@property (nonatomic,copy) NSString *strPrice;


@end

NS_ASSUME_NONNULL_END

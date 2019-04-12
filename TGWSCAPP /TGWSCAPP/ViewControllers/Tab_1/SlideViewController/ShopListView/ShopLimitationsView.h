//
//  ShopLimitationsView.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/4/12.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ShopLimitationsViewDelegate<NSObject>
@optional

-(void)didShopLimitationsClickButtonAtObejct:(ShopModel*)clickObj;

@end

@interface ShopLimitationsView : UIView


//  columnOneCount - 第一行的元素个数
//  columnTwoCount - 第二行之后的 每行的元素个数
-(ShopLimitationsView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
                  columnOneCount:(int)columnOneCount  columnTwoCount:(int)columnTwoCount;


@property (nonatomic, strong) id<ShopLimitationsViewDelegate> delegate;

@property (nonatomic,strong) ShopModel  *shopModel;

@end

NS_ASSUME_NONNULL_END

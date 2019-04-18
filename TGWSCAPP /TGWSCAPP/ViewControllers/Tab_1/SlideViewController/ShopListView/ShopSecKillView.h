//
//  ShopSecKillView.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/4/12.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ShopSecKillViewDelegate<NSObject>
@optional

-(void)didShopSecKillClickButtonAtObejct:(ShopModel*)clickObj;

@end


@interface ShopSecKillView : UIView


//  columnOneCount - 第一行的元素个数
//  columnTwoCount - 第二行之后的 每行的元素个数
-(ShopSecKillView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
                 columnOneCount:(int)columnOneCount  columnTwoCount:(int)columnTwoCount;


@property (nonatomic, strong) id<ShopSecKillViewDelegate> delegate;

@property (nonatomic,strong) ShopModel  *shopModel;

@end

NS_ASSUME_NONNULL_END

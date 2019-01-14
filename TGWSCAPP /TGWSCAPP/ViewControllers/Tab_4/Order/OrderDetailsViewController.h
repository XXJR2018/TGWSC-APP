//
//  OrderDetailsViewController.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/1/10.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailsViewController : CommonViewController

@property(nonatomic ,copy)NSString *orderNo;

@property(nonatomic,copy)Block_Void cancelOrderBlock;   //取消订单

@property(nonatomic,copy)Block_Void deleteOrderBlock;  //删除订单

@property(nonatomic,copy)Block_Void confirmGoodsBlock;  //确认收货

@property(nonatomic,copy)Block_Void againShopBlock;    //再次购买


@end

NS_ASSUME_NONNULL_END

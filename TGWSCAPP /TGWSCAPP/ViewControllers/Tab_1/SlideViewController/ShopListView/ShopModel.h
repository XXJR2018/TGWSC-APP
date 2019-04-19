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
@property (nonatomic,assign) int   iIsSellOut;  //  "isSellOut": 0 代表售罄 1代表尚有库存
@property (nonatomic,assign) int   iSaleStatus;  // 0 saleStatus  已下架 1 出售中

@property (nonatomic,copy) NSString *strTypeCode;
@property (nonatomic,copy) NSString *strTypeName;


@property (nonatomic,copy) NSString *strCateCode;
@property (nonatomic,copy) NSString *strCateName;
@property (nonatomic,copy) NSString *strGoodsCode;
@property (nonatomic,copy) NSString *strGoodsName;
@property (nonatomic,copy) NSString *strGoodsSubName;
@property (nonatomic,copy) NSString *strGoodsImgUrl;
@property (nonatomic,copy) NSString *strMaxPrice;
@property (nonatomic,copy) NSString *strMinPrice;

// 为活动时， 格外添加的字段
@property (nonatomic,assign) int   iSkipType;  //  0 - 不跳转， 1 - 跳转本地页面，  2 - 跳转URL
@property (nonatomic,copy) NSString *strSkipUrl;


// 限时秒杀活动，限时抢购活动，格外添加的字端
@property (nonatomic,assign) int   iSeckillId;     // 秒杀活动ID
@property (nonatomic,assign) int   iSecKillStatus;  // 活动状态(0未开始 1进行中 2已结束 3已失效)
@property (nonatomic,assign) int   iQuota;  // 是否限购；0为不限购 其他为限购数量
@property (nonatomic,assign) int   iSeckillStock;  // 秒杀商品剩余件数
@property (nonatomic,assign) int   iCountDownSecond; // 剩余秒数
@property (nonatomic,copy) NSString *minPrice;  // 原价
@property (nonatomic,copy) NSString *seckillPrice; // 秒杀价
@property (nonatomic,copy) NSString *reducePrice;  // 价差（减xx元）


@end

NS_ASSUME_NONNULL_END

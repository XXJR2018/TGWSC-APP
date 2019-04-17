//
//  ShopSecKillDetailVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/4/17.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "ShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopSecKillDetailVC : CommonViewController

@property (nonatomic,strong) ShopModel  *shopModel;

//1.从首页showType进入 est=showType  esi=typeId
//2.从类目查询中进入  est= category esi= cateId
//3.从搜索中进入  est=search
//4.从购物车中进入  est=cart esi= cartId
//5从收藏中进入 est=favorite esi=favoriteId
@property (nonatomic,strong) NSString  *est;
@property (nonatomic,strong) NSString  *esi;

@end

NS_ASSUME_NONNULL_END

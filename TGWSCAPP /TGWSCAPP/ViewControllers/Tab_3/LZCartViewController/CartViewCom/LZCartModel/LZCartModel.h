//
//  LZCartModel.h
//  LZCartViewController
//
//  Created by LQQ on 16/5/18.
//  Copyright © 2016年 LQQ. All rights reserved.
//  https://github.com/LQQZYY/CartDemo
//  http://blog.csdn.net/lqq200912408
//  QQ交流: 302934443

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LZCartModel : NSObject
//自定义模型时,这三个属性必须有
@property (nonatomic,assign) BOOL select;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *marketPrice;  // 原价

//下面的属性可根据自己的需求修改
@property (nonatomic,strong) NSString *cartIdStr;
@property (nonatomic,strong) NSString *skuCodeStr;
@property (nonatomic,strong) NSString *sizeStr;
@property (nonatomic,strong) NSString *nameStr;
@property (nonatomic,strong) NSString *dateStr;
@property (nonatomic,strong) NSString  *imageStr;


@end

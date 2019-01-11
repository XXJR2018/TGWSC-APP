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

@property(nonatomic,copy)Block_Void countDownBlock;

@end

NS_ASSUME_NONNULL_END

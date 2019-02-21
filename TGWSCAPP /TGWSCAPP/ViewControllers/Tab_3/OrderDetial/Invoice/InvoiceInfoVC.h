//
//  InvoiceInfoVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/13.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceInfoVC : CommonViewController

@property(nonatomic, copy)Block_String invoiceBlock;

@property(nonatomic, copy)NSString *price;

@end

NS_ASSUME_NONNULL_END

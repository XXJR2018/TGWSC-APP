//
//  BalanceViewCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BalanceViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDicionary;

@property (weak, nonatomic) IBOutlet UILabel *titleLabrl;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNumber;

@property (weak, nonatomic) IBOutlet UILabel *changeNumLabel;


@end

NS_ASSUME_NONNULL_END

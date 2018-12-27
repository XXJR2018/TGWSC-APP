//
//  BalanceViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "BalanceViewCell.h"

@implementation BalanceViewCell



-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabrl.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"recordDesc"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"createTime"]];
    self.orderNumber.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"orderNo"]];
    if ([[_dataDicionary objectForKey:@"fundFlag"] intValue] == 1) {
         self.changeNumLabel.text = [NSString stringWithFormat:@"+%@",[_dataDicionary objectForKey:@"amount"]];
    }else{
        self.changeNumLabel.text = [NSString stringWithFormat:@"-%@",[_dataDicionary objectForKey:@"amount"]];
    }
   
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

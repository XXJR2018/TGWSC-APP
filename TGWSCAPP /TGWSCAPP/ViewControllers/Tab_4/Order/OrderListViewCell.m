//
//  OrderListViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "OrderListViewCell.h"

@implementation OrderListViewCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
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

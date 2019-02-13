//
//  AppraiseViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/13.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseViewCell.h"

@implementation AppraiseViewCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    [self.contentView removeAllSubviews];
    
    [self layoutUI];
    [self layoutSubviews];
}

#pragma --mark 手动布局cell内部j控件
-(void)layoutUI{
    
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

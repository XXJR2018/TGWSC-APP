//
//  AppraiseListCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/14.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseListCell.h"

@interface AppraiseListCell ()


@end

@implementation AppraiseListCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    [self.contentView removeAllSubviews];
    
    [self layoutUI];
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
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

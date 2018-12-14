//
//  ProductCollectionViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ProductCollectionViewCell.h"

@implementation ProductCollectionViewCell


-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.productNameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"title"]];
    
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end

//
//  SortProductCollectionViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/21.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SortProductCollectionViewCell.h"

@implementation SortProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [ResourceManager color_5].CGColor;
    
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:[_dataDicionary objectForKey:@"imgUrl"]]];
    self.productNameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"goodsName"]];
    self.productSubNameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"goodsSubName"]];
    
    if ([[_dataDicionary objectForKey:@"marketPrice"] intValue] > 0 && [[_dataDicionary objectForKey:@"minPrice"] intValue] > 0) {
        NSString *minPrice = [NSString stringWithFormat:@"￥%@",[_dataDicionary objectForKey:@"minPrice"]];
        NSString *marketPrice = [NSString stringWithFormat:@"￥%@",[_dataDicionary objectForKey:@"marketPrice"]];
        NSString *titleStr = [NSString stringWithFormat:@"%@ %@",minPrice,marketPrice];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                              initWithString:titleStr];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, minPrice.length)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(minPrice.length + 1, marketPrice.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xB41D25) range:NSMakeRange(0, minPrice.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_6] range:NSMakeRange(minPrice.length + 1, marketPrice.length)];
        [attrStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(minPrice.length + 1, marketPrice.length)];
    
        self.priceLabel.attributedText = attrStr;
    }else if ([[_dataDicionary objectForKey:@"minPrice"] intValue] > 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[_dataDicionary objectForKey:@"minPrice"]];
    }
    
}

@end

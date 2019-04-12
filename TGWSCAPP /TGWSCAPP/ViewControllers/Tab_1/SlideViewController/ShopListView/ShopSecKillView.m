//
//  ShopSecKillView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/4/12.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "ShopSecKillView.h"


@interface ShopSecKillView ()
{
    NSString *_title;
    NSArray *_items;
    CGFloat _origin_Y;
    int  _columnOneCount; // 第一行的元素个数
    int  _columnTwoCount; // 第二行之后的 每行的元素个数
}
@end

@implementation ShopSecKillView

-(ShopSecKillView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
                 columnOneCount:(int)columnOneCount  columnTwoCount:(int)columnTwoCount
{
    self =  [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, 100)];
    
    _title = title;
    _items = items;
    _origin_Y = origin_Y;
    _columnOneCount = columnOneCount; // 第一行的元素个数
    _columnTwoCount = columnTwoCount; // 第二行之后的 每行的元素个数
    
    //[self drawListTwo];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

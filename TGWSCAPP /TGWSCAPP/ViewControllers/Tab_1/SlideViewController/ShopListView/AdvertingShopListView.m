//
//  AdvertingShopListView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "AdvertingShopListView.h"

@implementation AdvertingShopListView
{
    NSString *_title;
    NSArray *_items;
    CGFloat _origin_Y;
}



-(AdvertingShopListView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
{
    self =  [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, 100)];
    
    _title = title;
    _items = items;
    _origin_Y = origin_Y;
    
    [self drawList];
    
    return self;
}

-(void) drawList
{
    int iTopY = 0;
    int iLeftX = 15*ScaleSize;
    int iTitleHeight = 40;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 100, iTitleHeight)];
    [self addSubview:labelTitle];
    labelTitle.font = [ResourceManager font_1];
    
    
    
    
}

@end

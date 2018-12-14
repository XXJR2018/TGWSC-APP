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
    float fTopY = 0;
    float fLeftX = 15*ScaleSize;
    int iTitleHeight = 50;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH - fLeftX - 100, iTitleHeight)];
    [self addSubview:labelTitle];
    labelTitle.font = [ResourceManager fontTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.text = _title;
    
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, fTopY, 80, iTitleHeight)];
    [self addSubview:btnRight];
    [btnRight setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    [btnRight setTitle:@"更多>" forState:UIControlStateNormal];
    btnRight.titleLabel.font = [ResourceManager mainFont];
    
    
    fTopY +=labelTitle.height;
    
    if (_items &&
        [_items count])
     {
        UIImage *imgTemp = [UIImage imageNamed:_items[0]];
        
        
        float fImgHeight = imgTemp.size.height *ScaleSize;
        float fImgWidth = imgTemp.size.width *ScaleSize;
        float fImgTopY = fTopY;
        float fImgBettewn = 5 *ScaleSize;
        fLeftX = (SCREEN_WIDTH  - 2 *fImgWidth - fImgBettewn)/2;
        float fImgLeftX = fLeftX;
        
        for (int i = 0; i < [_items count]; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            imgViewTemp.image  = [UIImage imageNamed:_items[i]];
            
            if ((i +1) %2 == 0)
             {
                fImgTopY += fImgHeight + fImgBettewn;
                fImgLeftX = fLeftX;
             }
            else
             {
                fImgLeftX += fImgBettewn + fImgWidth;
             }
            
            
            
         }
//        NSLog(@"imgTemp.size.height: %f, imgTest.size.width: %f" ,fImgHeight,fImgWidth);
//        UIImageView *imgViewLeft = [[UIImageView alloc] initWithFrame:CGRectMake(fLeftX, fTopY, fImgWidth, fImgHeight)];
//        [self  addSubview:imgViewLeft];
//        imgViewLeft.image  = imgTemp;
//
//        UIImageView *imgViewRight = [[UIImageView alloc] initWithFrame:CGRectMake(2*fLeftX+ fImgWidth, fTopY, fImgWidth, fImgHeight)];
//        [self  addSubview:imgViewRight];
//        imgViewRight.image  = imgTemp;
     }
    
    
    
    
    
    
}

@end

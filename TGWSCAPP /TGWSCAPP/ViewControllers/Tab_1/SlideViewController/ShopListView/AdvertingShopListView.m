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
    
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, fTopY+3, 80, iTitleHeight)];
    [self addSubview:btnRight];
    [btnRight setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    [btnRight setTitle:@"更多>" forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnRight addTarget:self action:@selector(actionMore) forControlEvents:UIControlEventTouchUpInside];
    
    
    fTopY +=labelTitle.height;
    
    float fImgTopY = fTopY;
    if (_items &&
        [_items count])
     {
        ShopModel *sModel= _items[0];
        NSString *strImgName = sModel.strShopImgUrl;
        UIImage *imgTemp = [ToolsUtlis getImgFromStr:strImgName];
        if (!imgTemp)
         {
            return;
         }
        
        float fImgHeight = imgTemp.size.height *ScaleSize;
        float fImgWidth = imgTemp.size.width *ScaleSize;
        fImgTopY = fTopY;
        float fImgBettewn = 5 *ScaleSize;
        fLeftX = (SCREEN_WIDTH  - 2 *fImgWidth - fImgBettewn)/2;
        float fImgLeftX = fLeftX;
        
        for (int i = 0; i < [_items count]; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            
            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strShopImgUrl;
            imgTemp = [ToolsUtlis getImgFromStr:strImgName];
            imgViewTemp.image  = imgTemp;
            
            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
            
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

     }
    
    self.height = fImgTopY;
    
    
    
}

#pragma mark --- action
-(void) actionMore
{
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtObejct:)]) {
        ShopModel *mode = [[ShopModel alloc] init];
        mode.iShopID = -1;
        [self.delegate didClickButtonAtObejct:mode];
    }
}

-(void) actionImg:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (iTag < [_items count])
     {
        ShopModel *sModel = _items[iTag];
        if ([self.delegate respondsToSelector:@selector(didClickButtonAtObejct:)]) {
            [self.delegate didClickButtonAtObejct:sModel];
        }
     }
}

@end

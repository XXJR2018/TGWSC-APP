//
//  ShopListView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ShopListView.h"

@implementation ShopListView
{
    NSString *_title;
    NSArray *_items;
    CGFloat _origin_Y;
    int _columnCount;  // 总共有多少列
}


-(ShopListView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items  columnCount:(int)columnCount origin_Y:(CGFloat)origin_Y
{
    self =  [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, 100)];
    
    _title = title;
    _items = items;
    _columnCount = columnCount;
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
        //fLeftX = (SCREEN_WIDTH  - 2 *fImgWidth - fImgBettewn)/2;
        fLeftX = (SCREEN_WIDTH  - _columnCount *fImgWidth - fImgBettewn)/_columnCount;
        float fImgLeftX = fLeftX;
        
        float fLabelNameHeight = 45.f;
        float fLablePriceHeight = 20.f;
        
        for (int i = 0; i < [_items count]; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            
            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strShopImgUrl;
            imgTemp = [ToolsUtlis getImgFromStr:strImgName];
            imgViewTemp.image  = imgTemp;
            
            UILabel *labelShopName = [[UILabel alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY + fImgHeight, fImgWidth, fLabelNameHeight)];
            [self addSubview:labelShopName];
            //labelShopName.backgroundColor = [UIColor yellowColor];
            labelShopName.font = [UIFont systemFontOfSize:13];
            labelShopName.textColor = [ResourceManager color_1];
            labelShopName.text = sModel.strShopName;
            labelShopName.numberOfLines = 0;
            
            
            UILabel *labelShopPrice = [[UILabel alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY + fImgHeight + fLabelNameHeight, fImgWidth, fLablePriceHeight)];
            [self addSubview:labelShopPrice];
            //labelShopName.backgroundColor = [UIColor yellowColor];
            labelShopPrice.font = [UIFont systemFontOfSize:15];
            labelShopPrice.textColor = UIColorFromRGB(0x9f1421);
            labelShopPrice.text = sModel.strPrice;
            labelShopPrice.numberOfLines = 0;
            
            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
            
            if ((i +1) %_columnCount == 0)
             {
                fImgTopY += fImgHeight + fImgBettewn + fLabelNameHeight + fLablePriceHeight + fImgBettewn;
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
    if ([self.delegate respondsToSelector:@selector(didShopClickButtonAtObejct:)]) {
        ShopModel *mode = [[ShopModel alloc] init];
        mode.iShopID = -1;
        mode.strShopName = _title;
        [self.delegate didShopClickButtonAtObejct:mode];
    }
}

-(void) actionImg:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (iTag < [_items count])
     {
        ShopModel *sModel = _items[iTag];
        if ([self.delegate respondsToSelector:@selector(didShopClickButtonAtObejct:)]) {
            [self.delegate didShopClickButtonAtObejct:sModel];
        }
     }
}


@end
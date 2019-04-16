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
    
    [self drawListTwo];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 根据特殊参数来画
-(void) drawListTwo
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
    if(_items &&
       [_items count] &&
       _columnOneCount == 1  &&
       _columnTwoCount == 1)
     {
        // 一排一个时， 图片占位1/3屏幕宽
        float fImgBettewn = 5 *ScaleSize;
        float fImgHeight = (SCREEN_WIDTH - 2*fLeftX - (3 -1)* fImgBettewn) / 3 + 20;
        float fImgWidth = fImgHeight;
        
        int iShopCount = (int)[_items count];
        float fImgLeftX = fLeftX;
        for (int i = 0;  i < iShopCount; i++)
         {
            
            // 左边的图片
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            
            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strGoodsImgUrl;
            //imgTemp = [ToolsUtlis getImgFromStr:strImgName];
            //imgViewTemp.image  = imgTemp;
            [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:strImgName]];
            
            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY+fImgWidth, fImgWidth, 30)];
            [self addSubview:viewBottom];
            viewBottom.backgroundColor = UIColorFromRGB(0xa9454f);
            
            UILabel *labelBottom1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 40, viewBottom.height)];
            [viewBottom addSubview:labelBottom1];
            //labelBottom1.backgroundColor = [UIColor yellowColor];
            labelBottom1.textColor = [UIColor whiteColor];
            labelBottom1.font = [UIFont systemFontOfSize:11];
            labelBottom1.text = @"距结束";
            
            UILabel *labelBottom2 = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, viewBottom.width - 45 -5, viewBottom.height)];
            [viewBottom addSubview:labelBottom2];
            //labelBottom1.backgroundColor = [UIColor yellowColor];
            labelBottom2.textColor = [UIColor whiteColor];
            labelBottom2.font = [UIFont systemFontOfSize:11];
            labelBottom2.textAlignment = NSTextAlignmentRight;
            labelBottom2.text = @"20天12:12:12";
            
            
            
            //右边的文字
            float  fLabLeftX = fLeftX + 2*fImgBettewn + fImgWidth;
            float  fLabTopY = fImgTopY + 10;
            float  fLabWidth = SCREEN_WIDTH - 2*fImgBettewn - fLabLeftX;
            
            UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(fLabLeftX, fLabTopY, fLabWidth, 40)];
            [self  addSubview:labelName];
            labelName.font = [UIFont systemFontOfSize:15];
            labelName.textColor = [ResourceManager color_1];
            labelName.numberOfLines = 0;
            labelName.text = sModel.strGoodsName;
            

            fLabTopY += labelName.height + 10;
            UILabel *labelYH = [[UILabel alloc] initWithFrame:CGRectMake(fLabLeftX, fLabTopY, 200, 20)];
            [self  addSubview:labelYH];
            labelYH.backgroundColor = UIColorFromRGB(0xf8eae9);
            labelYH.font = [UIFont systemFontOfSize:11];
            labelYH.textColor = [ResourceManager priceColor];
            labelYH.text = [NSString stringWithFormat:@" 减%@元 ", sModel.reducePrice] ;
            labelYH.layer.borderColor = UIColorFromRGB(0xccb9bd).CGColor;
            labelYH.layer.borderWidth = 0.6;
            labelYH.layer.masksToBounds = YES;
            labelYH.layer.cornerRadius = 2;
            [labelYH sizeToFit];
            labelYH.height = 20;
            
            float fLabeSubLeftX = fLabLeftX + labelYH.width + 5;
            UILabel *labelSubName = [[UILabel alloc] initWithFrame:CGRectMake(fLabeSubLeftX, fLabTopY , fLabWidth - labelYH.width -10, 20)];
            [self  addSubview:labelSubName];
            labelSubName.font = [UIFont systemFontOfSize:14];
            labelSubName.textColor = [ResourceManager midGrayColor];
            labelSubName.text = sModel.strGoodsSubName;
            
            
            fLabTopY += labelSubName.height + 40;
            UILabel *labelSeckillPricee = [[UILabel alloc] initWithFrame:CGRectMake(fLabLeftX, fLabTopY, fLabWidth, 40)];
            [self  addSubview:labelSeckillPricee];
            labelSeckillPricee.font = [UIFont systemFontOfSize:18];
            labelSeckillPricee.textColor = [ResourceManager priceColor];
            labelSeckillPricee.text =  [NSString stringWithFormat:@"¥%@",sModel.seckillPrice];
            [labelSeckillPricee sizeToFit];
            
            
            UILabel *labelMinPrice = [[UILabel alloc] initWithFrame:CGRectMake(fLabLeftX + labelSeckillPricee.width + 5, fLabTopY, fLabWidth, 40)];
            [self  addSubview:labelMinPrice];
            labelMinPrice.font = [UIFont systemFontOfSize:15];
            labelMinPrice.textColor = [ResourceManager midGrayColor];
            NSString *strMinePrice =  [NSString stringWithFormat:@"¥%@",sModel.strMinPrice];
            // 中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:strMinePrice attributes:attribtDic];
            labelMinPrice.attributedText = attribtStr;
            
            [labelMinPrice sizeToFit];
            
            float fLabeSeckillStockLeftX = fLabLeftX + labelSeckillPricee.width + labelMinPrice.width + 8;
            UILabel *labelSeckillStock = [[UILabel alloc] initWithFrame:CGRectMake(fLabeSeckillStockLeftX, fLabTopY , fLabWidth - labelSeckillPricee.width - labelMinPrice.width -15, 20)];
            [self  addSubview:labelSeckillStock];
            labelSeckillStock.font = [UIFont systemFontOfSize:13];
            labelSeckillStock.textColor = [ResourceManager midGrayColor];
            labelSeckillStock.textAlignment = NSTextAlignmentRight;
            labelSeckillStock.text = [NSString stringWithFormat:@"仅剩%d件", sModel.iSeckillStock];
            
            
            // 换行，画另一个元素
            fImgTopY += fImgBettewn + fImgWidth + 30 +20;
            fImgLeftX = fLeftX;
            
            // 分割线
            if (i < (iShopCount -1))
             {
                UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(fImgBettewn, fImgTopY-12, SCREEN_WIDTH - 2*fImgBettewn, 1)];
                [self addSubview:viewFG];
                viewFG.backgroundColor = [ResourceManager color_5];
             }
         }
        
     }
     else if (_items &&
        [_items count])
     {
        
        int iShopCount = (int)[_items count];
        // 画第一行
        float fImgBettewn = 5 *ScaleSize;
        float fImgHeight = (SCREEN_WIDTH - 2*fLeftX - (_columnOneCount -1)* fImgBettewn) / _columnOneCount;
        float fImgWidth = fImgHeight;
        fImgTopY = fTopY;
        fLeftX = (SCREEN_WIDTH  - _columnOneCount *fImgWidth - (_columnOneCount - 1)*fImgBettewn)/ 2;
        
        
        float fImgLeftX = fLeftX;
        
        for (int i = 0;  i < _columnOneCount; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            
            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strGoodsImgUrl;
            //imgTemp = [ToolsUtlis getImgFromStr:strImgName];
            //imgViewTemp.image  = imgTemp;
            [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:strImgName]];
            
            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            fImgLeftX += fImgBettewn + fImgWidth;
            
         }
        
        
        
        // 如果只有一排
        if (_columnOneCount == iShopCount ||
            _columnTwoCount == 0)
         {
            fImgTopY += fImgHeight + fImgBettewn;
            self.height = fImgTopY;
            return;
         }
        
        // 画第二排
        fImgHeight = (SCREEN_WIDTH - 2*fLeftX - (_columnTwoCount -1)* fImgBettewn) / _columnTwoCount;
        fImgWidth = fImgHeight;
        //fImgTopY = fTopY;
        fImgTopY += fImgHeight + fImgBettewn;
        fImgBettewn = 1.5 *ScaleSize;
        fLeftX = (SCREEN_WIDTH  - _columnTwoCount *fImgWidth - (_columnTwoCount - 1)*fImgBettewn)/2;
        
        if (_columnTwoCount == 1)
         {
            fLeftX = 11 * ScaleSize;
            fImgWidth = SCREEN_WIDTH - 2*fLeftX;
         }
        
        fImgLeftX = fLeftX;
        
        for (int i = _columnOneCount; i < iShopCount; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            
            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strGoodsImgUrl;
            //imgTemp = [ToolsUtlis getImgFromStr:strImgName];
            //imgViewTemp.image  = imgTemp;
            [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:strImgName]];
            
            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
            
            if ((i +1 - _columnOneCount) %_columnTwoCount == 0)
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
    if ([self.delegate respondsToSelector:@selector(didShopSecKillClickButtonAtObejct:)]) {
        ShopModel *mode = [[ShopModel alloc] init];
        mode = _shopModel;
        _shopModel.iShopID = -1;
        [self.delegate didShopSecKillClickButtonAtObejct:_shopModel];
    }
}

-(void) actionImg:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (iTag < [_items count])
     {
        ShopModel *sModel = _items[iTag];
        if ([self.delegate respondsToSelector:@selector(didShopSecKillClickButtonAtObejct:)]) {
            [self.delegate didShopSecKillClickButtonAtObejct:sModel];
        }
     }
}


@end

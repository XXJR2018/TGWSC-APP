//
//  ProductViewCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/17.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ProductViewCell;
@protocol ProductCellDelegate <NSObject>

/**
 * 动态改变UITableViewCell的高度
 */
- (void)updateTableViewCellHeight:(ProductViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath;

/**
 * 点击UICollectionViewCell的代理方法
 */
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(NSString *)content;

@end

@interface ProductViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<ProductCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSArray *dataAry;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) CGFloat heightED;

@end


//
//  ProductViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/17.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ProductViewCell.h"

#import "ProductCollectionViewCell.h"

@implementation ProductViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self.heightED = 0;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
        self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, self.contentView.frame.size.height);
    }
    return self;
}

#pragma mark ====== UICollectionViewDelegate ======
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *arr = self.dataAry[section];
   return arr.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView"forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            _headerView = [[UIView alloc] init];
            _headerView.backgroundColor = [UIColor whiteColor];
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 130, 100)];
            [_headerView addSubview:imgView];
            imgView.image = [UIImage imageNamed:@"Tab_4-9"];
            
            UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imgView.frame), 150, 40)];
            titleLabel.text = @"我是标题";
            titleLabel.font= [UIFont boldSystemFontOfSize:15];
            titleLabel.textColor = [ResourceManager color_1];
            [_headerView addSubview:titleLabel];
            
            UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH - 130, 0.5)];
            [_headerView addSubview:viewX];
            viewX.backgroundColor = [ResourceManager color_5];
            _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, CGRectGetMaxY(viewX.frame));
            
            //头视图添加view
            [header addSubview:_headerView];
        }else{
            //添加头视图的内容
            _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 40)];
            _headerView.backgroundColor = [UIColor whiteColor];
            UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 40)];
            titleLabel.text = @"我是标题";
            titleLabel.font= [UIFont boldSystemFontOfSize:15];
            titleLabel.textColor = [ResourceManager color_1];
            [_headerView addSubview:titleLabel];
            
            UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH - 130, 0.5)];
            [_headerView addSubview:viewX];
            viewX.backgroundColor = [ResourceManager color_5];
            _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, CGRectGetMaxY(viewX.frame));
            
            //头视图添加view
            [header addSubview:_headerView];
        }
        
        return header;
    }
    return nil;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    CGSize size = CGSizeZero;
//    if (section == 0) {
//        size = CGSizeMake(SCREEN_WIDTH - 100, 140);
//    }else{
//        size = CGSizeMake(SCREEN_WIDTH - 100, 40);
//    }
//    return size;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCell_ID" forIndexPath:indexPath];
    NSArray *arr = self.dataAry[indexPath.section];
    cell.dataDicionary = arr[indexPath.row];
    [self updateCollectionViewHeight:self.collectionView.collectionViewLayout.collectionViewContentSize.height];
    return cell;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:withContent:)]) {
        [self.delegate didSelectItemAtIndexPath:indexPath withContent:self.dataAry[indexPath.row]];
    }
}

#pragma mark- FlowDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70 * ScaleSize, 100 * ScaleSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, (SCREEN_WIDTH - 100 - 70 * 3)/6, 5, (SCREEN_WIDTH - 100 - 70 * 3)/6);
}




- (void)updateCollectionViewHeight:(CGFloat)height {
    if (self.heightED != height) {
        self.heightED = height;
        self.collectionView.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, height);
        
        if (_delegate && [_delegate respondsToSelector:@selector(updateTableViewCellHeight:andheight:andIndexPath:)]) {
            [self.delegate updateTableViewCellHeight:self andheight:height andIndexPath:self.indexPath];
        }
    }
}

#pragma mark ====== init ======
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        [self collectionViewUI];
    }
    return _collectionView;
}

- (void)setDataAry:(NSArray *)dataAry {
    //    [self.collectionView reloadData];
    self.heightED = 0;
    _dataAry = dataAry;
}

#pragma mark === collectionViewUI
-(void)collectionViewUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = (SCREEN_WIDTH - 100 - 210)/6 * ScaleSize;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, SCREEN_HEIGHT - TabbarHeight - NavHeight) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    
    //以xib方式注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"ProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductCell_ID"];
    //注册头视图，相当于段头
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
}

@end

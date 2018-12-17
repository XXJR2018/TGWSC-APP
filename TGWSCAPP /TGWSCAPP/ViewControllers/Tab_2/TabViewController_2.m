//
//  TabViewController_2.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_2.h"

#import "ProductCollectionViewCell.h"


@interface TabViewController_2 ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIScrollView *_scView;
    UIButton *_sortFirstBtn;
    UIView *_sortFristView;
    NSMutableArray *_sortFirstTitleArr;
    NSMutableArray *_sortFirstBtnArr;
    
    
    UICollectionView *_collectView;
    UIView *_headerView;
    
    NSMutableArray *_sortSecondTitleArr;
    NSMutableArray *_sortSecondDataArr;
}
@end

@implementation TabViewController_2

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"分类"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"分类"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideBackButton = YES;
    [self layoutNaviBarViewWithTitle:@"分类"];
    
    _sortFirstBtnArr = [NSMutableArray array];
    _sortFirstTitleArr = [NSMutableArray arrayWithArray:@[@"冬季专区",@"爆品专区",@"新品专区",@"居家",@"鞋包配饰",@"服装",@"洗护",@"饮食",@"母婴",@"餐厨",@"保健",@"文体",@"12.12专区",@"特色区"]];
    _sortSecondTitleArr = [NSMutableArray arrayWithArray:@[@[@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"}],
  @[@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"}],
  @[@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"包包"}]]];
    
    _sortSecondDataArr = [NSMutableArray arrayWithArray:_sortSecondTitleArr];
    
    [self layoutUI];
    [self rightListUI];
}

-(void)layoutUI{
    
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, 100, SCREEN_HEIGHT - NavHeight - TabbarHeight)];
    [self.view addSubview:_scView];
    _scView.backgroundColor = [UIColor whiteColor];
    _scView.bounces = NO;
    _scView.pagingEnabled = NO;
    _scView.showsVerticalScrollIndicator = NO;
    
    UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_scView.frame) - 0.5, 0, 0.5, CGRectGetMaxY(_scView.frame))];
    [_scView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    
    for (int i = 0; i < _sortFirstTitleArr.count; i ++) {
        _sortFirstBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50 * i, 100, 50)];
        [_scView addSubview:_sortFirstBtn];
        _sortFirstBtn.tag = i + 100;
        [_sortFirstBtn setTitle:_sortFirstTitleArr[i] forState:UIControlStateNormal];
        [_sortFirstBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [_sortFirstBtn setTitleColor:[ResourceManager redColor1] forState:UIControlStateSelected];
        _sortFirstBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sortFirstBtn addTarget:self action:@selector(sortFirstTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [_sortFirstBtnArr addObject:_sortFirstBtn];
        
    }
    
    _scView.contentSize =CGSizeMake(0, CGRectGetMaxY(_sortFirstBtn.frame) + 10);
    ((UIButton *)_sortFirstBtnArr[0]).selected = YES;
    _sortFristView = [[UIView alloc]initWithFrame:CGRectMake(0, (50 - 20)/2, 2, 20)];
    [_scView addSubview:_sortFristView];
    _sortFristView.backgroundColor = [ResourceManager redColor1];
    
}

#pragma mark- 右边商品列表布局
-(void)rightListUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = (SCREEN_WIDTH - 100 - 210)/6 * ScaleSize;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(100, NavHeight, SCREEN_WIDTH - 100, SCREEN_HEIGHT - TabbarHeight - NavHeight) collectionViewLayout:flowLayout];
    _collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectView];
    _collectView.showsVerticalScrollIndicator = NO;
    _collectView.delegate = self;
    _collectView.dataSource = self;
    //以xib方式注册cell
    [_collectView registerNib:[UINib nibWithNibName:@"ProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductCell_ID"];
    //注册头视图，相当于段头
    [_collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
}




#pragma mark-一级菜单点击事件
-(void)sortFirstTouch:(UIButton *)sender{
    
    if (sender == _sortFirstBtn) {
        return;
    }
    NSLog(@"%@",_sortFirstTitleArr[sender.tag - 100]);
    ((UIButton *)_sortFirstBtnArr[0]).selected = NO;
    if (sender != _sortFirstBtn) {
        _sortFirstBtn.selected = NO;
        _sortFirstBtn = sender;
    }else{
        //避免重复点击
        return;
    }
    _sortFirstBtn.selected = YES;
    _sortFristView.frame = CGRectMake(0, (50 - 20)/2 + (sender.tag - 100) * 50, 2, 20);
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
         return  4;
    }else if (section == 1) {
        return  5;
    }else{
        return  8;
    }
    
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    if (section == 0) {
        size = CGSizeMake(SCREEN_WIDTH - 100, 140);
    }else{
        size = CGSizeMake(SCREEN_WIDTH - 100, 40);
    }
    return size;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductCollectionViewCell * cell;
    cell = (ProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCell_ID" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        NSArray *arr = _sortSecondTitleArr[0];
        cell.dataDicionary = arr[indexPath.row];
    }else if (indexPath.section == 1) {
        NSArray *arr = _sortSecondTitleArr[1];
        cell.dataDicionary = arr[indexPath.row];
    }else{
        NSArray *arr = _sortSecondTitleArr[2];
        cell.dataDicionary = arr[indexPath.row];
    }
    
    return cell;
    
}

#pragma mark- FlowDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70 * ScaleSize, 100 * ScaleSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, (SCREEN_WIDTH - 100 - 70 * 3)/6, 5, (SCREEN_WIDTH - 100 - 70 * 3)/6);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductCollectionViewCell * cell = (ProductCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
   
}



-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}




@end

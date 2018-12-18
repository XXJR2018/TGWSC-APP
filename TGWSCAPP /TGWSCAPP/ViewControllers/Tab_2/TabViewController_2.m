//
//  TabViewController_2.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_2.h"

#import "ProductCollectionViewCell.h"


@interface TabViewController_2 ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIScrollView *_scView;
    UIButton *_sortFirstBtn;
    UIView *_sortFristView;
    NSMutableArray *_sortFirstTitleArr;
    NSMutableArray *_sortFirstBtnArr;
    
    UITableView *_tableView;
    UICollectionView *_collectView;
    UIView *_headerView;
    
    
    
    NSMutableArray *_sortSecondTitleArr;
    NSInteger cellCount;   //当前的cell是第几个
    BOOL ToRowSuccess;   //是否可以进行跳cell
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
    _sortSecondTitleArr = [NSMutableArray array];
    
    NSArray *arr1 = @[@[@{@"title":@"箱子1"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"}],
                      @[@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"}],
                      @[@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"}]];
    NSArray *arr2 = @[@[@{@"title":@"箱子2"}],
                      @[@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"箱子"}],
                      @[@{@"title":@"箱子"},@{@"title":@"包包"}]];
    NSArray *arr3 = @[@[@{@"title":@"箱子3"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"}],
                      @[@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"}],
                      @[@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"包包"}]];
    NSArray *arr4 = @[@[@{@"title":@"箱子4"},@{@"title":@"箱子"},@{@"title":@"包包"}],
                      @[@{@"title":@"箱子"},@{@"title":@"包包"}],
                      @[@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"},@{@"title":@"包包"},@{@"title":@"箱子"},@{@"title":@"包包"}]];
    [self.dataArray addObject:arr1];
    [self.dataArray addObject:arr2];
    [self.dataArray addObject:arr3];
    [self.dataArray addObject:arr4];
    
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
        _sortFirstBtn.tag = i;
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

#pragma mark-一级菜单点击事件
-(void)sortFirstTouch:(UIButton *)sender{
    
    if (sender == _sortFirstBtn) {
        return;
    }
    NSLog(@"%@",_sortFirstTitleArr[sender.tag]);
    ((UIButton *)_sortFirstBtnArr[0]).selected = NO;
    if (sender != _sortFirstBtn) {
        _sortFirstBtn.selected = NO;
        _sortFirstBtn = sender;
    }else{
        //避免重复点击
        return;
    }
    _sortFirstBtn.selected = YES;
    _sortFristView.frame = CGRectMake(0, (50 - 20)/2 + (sender.tag) * 50, 2, 20);
    
    /* 滚动指定段的指定row  到 指定位置*/
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    cellCount = sender.tag;
}

#pragma mark- 右边商品列表布局
-(void)rightListUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(100, NavHeight, SCREEN_WIDTH - 100, SCREEN_HEIGHT - TabbarHeight - NavHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    //初始化加载显示第0个cell
    cellCount = 0;
    ToRowSuccess = YES;
}

-(void)collectionViewUI:(NSInteger)section{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = (SCREEN_WIDTH - 100 - 210)/6 * ScaleSize;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, SCREEN_HEIGHT - NavHeight - TabbarHeight) collectionViewLayout:flowLayout];
    _collectView.backgroundColor = [UIColor whiteColor];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    //以xib方式注册cell
    [_collectView registerNib:[UINib nibWithNibName:@"ProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductCell_ID"];
    //注册头视图，相当于段头
    [_collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
}

#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  SCREEN_HEIGHT - NavHeight - TabbarHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"%ld_cell",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    _sortSecondTitleArr = self.dataArray[indexPath.row];
    [self collectionViewUI:indexPath.section];
    [cell.contentView addSubview:_collectView];
    
    
    return cell;
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dic = _sortSecondTitleArr[section];
    return  dic.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _sortSecondTitleArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView"forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            _headerView = [[UIView alloc] init];
            _headerView.backgroundColor = [UIColor whiteColor];
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH - 115, 100)];
            [_headerView addSubview:imgView];
            imgView.image = [UIImage imageNamed:@"Tab_4-9"];
            
            UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imgView.frame), 150, 40)];
            titleLabel.text = @"我是标题";
            titleLabel.font= [UIFont boldSystemFontOfSize:15];
            titleLabel.textColor = [ResourceManager color_1];
            [_headerView addSubview:titleLabel];
            
            UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) - 0.5, SCREEN_WIDTH - 130, 0.5)];
            [_headerView addSubview:viewX];
            viewX.backgroundColor = [ResourceManager color_5];
            _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 110, CGRectGetMaxY(viewX.frame));
            
            //头视图添加view
            [header addSubview:_headerView];
        }else{
            //添加头视图的内容
            _headerView = [[UIView alloc] init];
            _headerView.backgroundColor = [UIColor whiteColor];
            UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 40)];
            titleLabel.text = @"我是标题";
            titleLabel.font= [UIFont boldSystemFontOfSize:15];
            titleLabel.textColor = [ResourceManager color_1];
            [_headerView addSubview:titleLabel];
            
            UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) - 0.5, SCREEN_WIDTH - 130, 0.5)];
            [_headerView addSubview:viewX];
            viewX.backgroundColor = [ResourceManager color_5];
            _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 110, CGRectGetMaxY(viewX.frame));
            
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
        size = CGSizeMake(SCREEN_WIDTH - 100, 155);
    }else{
        size = CGSizeMake(SCREEN_WIDTH - 100, 40);
    }
    return size;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductCollectionViewCell * cell;
    cell = (ProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCell_ID" forIndexPath:indexPath];
    NSArray *arr = _sortSecondTitleArr[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    cell.dataDicionary = dic;
    
    return cell;
    
}

#pragma mark- FlowDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70 * ScaleSize, 100 * ScaleSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, (SCREEN_WIDTH - 100 - 70 * 3)/6, 5, (SCREEN_WIDTH - 100 - 70 * 3)/6);
}

//返回这个UICollectioncell是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductCollectionViewCell * cell = (ProductCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
}


#pragma mark-UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (!ToRowSuccess) {
        return;
    }
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - height;
    if (contentOffset - 100 < 0) {
        if (cellCount > 0) {
            NSLog(@"跳到上一个cell");
            cellCount = cellCount - 1;
            ToRowSuccess = NO;
            [self performSelector:@selector(tableViewToRow) withObject:nil afterDelay:0.2];
        }
    }
    
    if (contentOffset > distanceFromBottom + 100) {
        if (cellCount < self.dataArray.count - 1) {
            NSLog(@"跳到下一个cell");
            cellCount = cellCount + 1;
            ToRowSuccess = NO;
            [self performSelector:@selector(tableViewToRow) withObject:nil afterDelay:0.2];
        }
    }
    
}

-(void)tableViewToRow{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cellCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self sortFirstTouch:_sortFirstBtnArr[cellCount]];
    ToRowSuccess = YES;
}



-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}




@end

//
//  SearchSubVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SearchSubVC.h"
#import "SortProductCollectionViewCell.h"
#import "LLSearchVCConst.h"
#import "ShopDetailVC.h"

@interface SearchSubVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
}

@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *cellDic;

/*!
 @property  NSInteger pageIndex
 @brief     页码
 */
@property (nonatomic, assign) NSInteger pageIndex;
/*!
 @property  NSInteger pageIndex
 @brief     页大小
 */
@property (nonatomic, assign) NSInteger pageSizeCount;
/*!
 @property  BOOL pullDown
 @brief     上拉还是下拉
 */
@property (nonatomic, assign) BOOL pullDown;

/*!
 @property  BOOL isLoading
 @brief     是否正在刷新
 */
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation SearchSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self layoutUI];
}

-(void) initData
{
    _cellDic = [[NSMutableDictionary alloc] init];
    _pageSizeCount = 50;
    _pageIndex = 1;
    _pullDown = YES;
}

-(void)layoutUI
{
    self.view.backgroundColor = [UIColor yellowColor];
    
    NSLog(@"SearchSubVC  frame:%f", self.view.frame.size.height);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, self.view.height-100 - ZYHT_StatusBarAndNavigationBarHeight) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //以xib方式注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"SortProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SortProductCell_ID"];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    
    
    // 上拉刷新
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    //[self loadWebData];
    
}

#pragma mark 网络请求
-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kPage] = @(self.pageIndex);
    params[kPageSize] = @(self.pageSizeCount);
    if (_strSeacrhKey)
     {
        params[@"goodsName"] = _strSeacrhKey;//_strTypeCode;
     }
    //params[@"orderNum"] = @(1);  //1-价格升序 2-价格降序 3-销量降序
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kURLqueryGoodsByCondition];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strURL
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}

/*!
 @brief     刷新数据
 @return    void
 */
- (void)reloadData
{
    //reset status
    self.pullDown = YES;
    //修改分页
    self.pageIndex = 1;
    self.isLoading = YES;
    [self loadData];
}

/*
 * 加载更多
 **/
-(void)loadMoreData{
    //修改分页
    self.pageIndex ++ ;
    //reset status
    self.pullDown = NO;
    self.isLoading = YES;
    [self loadData];
}

- (void)reloadTableViewWithArray:(NSArray *)array
{
    
    if (self.pullDown){
        [self refreshTableViewWithArray:array];
       
    }else{
        [self refreshTableViewWithMoreArray:array];
    }
}

/*!
 @brief     刷新
 @return    void
 */
- (void)refreshTableViewWithArray:(NSArray *)array
{
    if (self.pullDown){
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:array];
    
    
    [_collectionView reloadData];
    

    
}

/*!
 @brief     加载更多
 @return    void
 */
- (void)refreshTableViewWithMoreArray:(NSArray *)array
{
    if (self.pullDown)
     {
        [self.dataArray removeAllObjects];
     }
    
    [self.dataArray addObjectsFromArray:array];
    
    [_collectionView reloadData];
    
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    self.isLoading = NO;
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
//    [_collectionView.mj_header endRefreshing];
//    [_collectionView.mj_footer endRefreshing];
//    [self.dataArray removeAllObjects];
//    [self.dataArray addObjectsFromArray:operation.jsonResult.rows];
//    [_collectionView reloadData];
    
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
    
    if (operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        self.pageIndex --;
        if (self.pageIndex >= 1) {
            [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
        }
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    
    self.pageIndex = self.pageIndex > 1 ? self.pageIndex - 1 : 1 ;
    self.isLoading = NO;
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}




#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //SortProductCollectionViewCell *cell = (SortProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SortProductCell_ID" forIndexPath:indexPath];
    
    // 防止复用时出问题
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"SearchSubVC", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];

        //以xib方式注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"SortProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }

    SortProductCollectionViewCell *cell = (SortProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    
    cell.dataDicionary = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark- FlowDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/2, 230 * ScaleSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//返回这个UICollectioncell是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    NSString *goodsCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsCode"]];
    if (goodsCode.length > 0) {
        ShopDetailVC *VC  = [[ShopDetailVC alloc] init];
        VC.shopModel = [[ShopModel alloc] init];
        VC.shopModel.strGoodsCode = goodsCode;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
}

@end

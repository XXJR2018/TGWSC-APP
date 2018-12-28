//
//  SearchSubVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SearchSubVC.h"
#import "SortProductCollectionViewCell.h"

@interface SearchSubVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
}

@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

@implementation SearchSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

// view 已经布局其 Subviews
- (void)viewDidLayoutSubviews
{
    
    [self layoutUI];
}



-(void)layoutUI
{
    self.view.backgroundColor = [UIColor yellowColor];
    
    NSLog(@"SearchSubVC  frame:%f", self.view.frame.size.height);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, self.view.height - 110) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //以xib方式注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"SortProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SortProductCell_ID"];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
}

@end

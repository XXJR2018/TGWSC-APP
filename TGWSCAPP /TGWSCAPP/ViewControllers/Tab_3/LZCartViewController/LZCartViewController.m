//
//  LZCartViewController.m
//  LZCartViewController
//
//  Created by LQQ on 16/5/18.
//  Copyright © 2016年 LQQ. All rights reserved.
//  https://github.com/LQQZYY/CartDemo
//  http://blog.csdn.net/lqq200912408
//  QQ交流: 302934443

#import "LZCartViewController.h"
#import "LZConfigFile.h"
#import "LZCartTableViewCell.h"
#import "LZCartModel.h"

@interface LZCartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL  isChildView ;  // 是否属于子页面
    BOOL  isHasTabBarController;
}

@property (strong,nonatomic)NSMutableArray *selectedArray;
@property (strong,nonatomic)UITableView *myTableView;
@property (strong,nonatomic)UIButton *allSellectedButton;
@property (strong,nonatomic)UILabel *totlePriceLabel;
@end

@implementation LZCartViewController

#pragma mark - viewController life cicle
- (void)viewWillAppear:(BOOL)animated {
    
    
    
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
    if (self.selectedArray.count > 0) {
        for (LZCartModel *model in self.selectedArray) {
            model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
        }
        [self.selectedArray removeAllObjects];
    }
    
    //初始化显示状态
    _allSellectedButton.selected = NO;
    _totlePriceLabel.attributedText = [self LZSetString:@"￥0.00"];
    
    [self loadData];
}

-(void)creatData {
    for (int i = 0; i < 10; i++) {
        LZCartModel *model = [[LZCartModel alloc]init];
        
        model.nameStr = [NSString stringWithFormat:@"测试数据%d",i];
        model.price = @"100.00";
        model.number = 1;
        model.imageStr = @"";//[UIImage imageNamed:@"aaa.jpg"];
        model.dateStr = @"2016.02.18";
        model.sizeStr = @"18*20cm";
        
        [self.dataArray addObject:model];
    }
}





- (LZCartViewController*)initWithVar:(BOOL)isChild
{
    self = [super init];

    self.hideBackButton = YES;
    isChildView = YES;
    isHasTabBarController = YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self layoutNaviBarViewWithTitle:@"购物车"];

    if (self.dataArray.count > 0) {
        
        [self setupCartView];
    } else {
        [self setupCartEmptyView];
    }
    
#warning 加载网络数据,会有延迟
    [self loadData];
    

}




- (void)viewWillDisappear:(BOOL)animated {
//    if (_isHiddenNavigationBarWhenDisappear == YES) {
//        self.navigationController.navigationBarHidden = NO;
//    }
}

/**
 *  @author LQQ, 16-02-18 11:02:16
 *
 *  计算已选中商品金额
 */
-(void)countPrice {
    double totlePrice = 0.0;
    
    for (LZCartModel *model in self.selectedArray) {
        
        double price = [model.price doubleValue];
        
        totlePrice += price*model.number;
    }
    NSString *string = [NSString stringWithFormat:@"￥%.2f",totlePrice];
    self.totlePriceLabel.attributedText = [self LZSetString:string];
}

#pragma mark - 初始化数组
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}

#pragma mark - 布局页面视图
#pragma mark -- 自定义底部视图 
- (void)setupCustomBottomView {
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = LZColorFromRGB(245, 245, 245);
    backgroundView.tag = TAG_CartEmptyView + 1;
    [self.view addSubview:backgroundView];
    
    //当有tabBarController时,在tabBar的上面
    if (isHasTabBarController == YES)
    {
        backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  LZTabBarHeight - TabbarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
    } else {
        backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  LZTabBarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, LZSCREEN_WIDTH, 1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:16];
    selectAll.frame = CGRectMake(10, 5, 80, LZTabBarHeight - 10);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:lz_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:lz_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = BASECOLOR_RED;
    btn.frame = CGRectMake(LZSCREEN_WIDTH - 80, 0, 80, LZTabBarHeight);
    [btn setTitle:@"去结算" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor redColor];
    [backgroundView addSubview:label];
    
    label.attributedText = [self LZSetString:@"¥0.00"];
    CGFloat maxWidth = LZSCREEN_WIDTH - selectAll.bounds.size.width - btn.bounds.size.width - 30;
//    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, LZTabBarHeight)];
    label.frame = CGRectMake(selectAll.bounds.size.width + 20, 0, maxWidth - 10, LZTabBarHeight);
    self.totlePriceLabel = label;
}

- (NSMutableAttributedString*)LZSetString:(NSString*)string {
    
    NSString *text = [NSString stringWithFormat:@"合计:%@",string];
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"合计:"];
    [LZString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:rang];
    return LZString;
}
#pragma mark -- 购物车为空时的默认视图
- (void)changeView {
    if (self.dataArray.count > 0) {
        UIView *view = [self.view viewWithTag:TAG_CartEmptyView];
        if (view != nil) {
            [view removeFromSuperview];
        }
        
        [self setupCartView];
    } else {
        UIView *bottomView = [self.view viewWithTag:TAG_CartEmptyView + 1];
        [bottomView removeFromSuperview];
        
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        [self setupCartEmptyView];
    }
}

- (void)setupCartEmptyView {
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, LZNaigationBarHeight, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight)];
    [self.view addSubview:backgroundView];
    backgroundView.tag = TAG_CartEmptyView;
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:lz_CartEmptyString]];
    img.center = CGPointMake(LZSCREEN_WIDTH/2.0, LZSCREEN_HEIGHT/2.0 - 180);
    img.bounds = CGRectMake(0, 0, 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(LZSCREEN_WIDTH/2.0, LZSCREEN_HEIGHT/2.0 - 90);
    warnLabel.bounds = CGRectMake(0, 0, LZSCREEN_WIDTH, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车还没有商品哦～";
    warnLabel.font = [UIFont systemFontOfSize:14];
    warnLabel.textColor = [ResourceManager lightGrayColor];
    [backgroundView addSubview:warnLabel];
    
    UIButton *btnShop = [[UIButton alloc] init];
    btnShop.center = CGPointMake(LZSCREEN_WIDTH/2.0, LZSCREEN_HEIGHT/2.0 - 30);
    btnShop.bounds = CGRectMake(0, 0, 100, 30);
    [backgroundView addSubview:btnShop];
    btnShop.cornerRadius = 4;
    [btnShop setTitle:@"去逛逛" forState:UIControlStateNormal];
    [btnShop setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnShop.titleLabel.font = [UIFont systemFontOfSize:14];
    btnShop.borderWidth = 0.3;
    btnShop.borderColor = [ResourceManager mainColor];
    [btnShop addTarget:self action:@selector(actonShop) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark -- 购物车有商品时的视图
- (void)setupCartView {
    //创建底部视图
    [self setupCustomBottomView];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    table.delegate = self;
    table.dataSource = self;
    
    table.rowHeight = lz_CartRowHeight;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = LZColorFromRGB(245, 246, 248);
    [self.view addSubview:table];
    self.myTableView = table;
    
    if (isHasTabBarController) {
        table.frame = CGRectMake(0, LZNaigationBarHeight, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - LZTabBarHeight - TabbarHeight);
    } else {
        table.frame = CGRectMake(0, LZNaigationBarHeight, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - LZTabBarHeight);
    }
}
#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
    if (cell == nil) {
        cell = [[LZCartTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LZCartReusableCell"];
    }
    
    LZCartModel *model = self.dataArray[indexPath.row];
    __block typeof(cell)wsCell = cell;
    
    [cell numberAddWithBlock:^(NSInteger number) {
        wsCell.lzNumber = number;
        model.number = number;
        
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell numberCutWithBlock:^(NSInteger number) {
        
        wsCell.lzNumber = number;
        model.number = number;
        
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell cellSelectedWithBlock:^(BOOL select) {
        
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        if (self.selectedArray.count == self.dataArray.count) {
            _allSellectedButton.selected = YES;
        } else {
            _allSellectedButton.selected = NO;
        }
        
        [self countPrice];
    }];
    
    [cell reloadDataWithModel:model];
    return cell;
}



// 自定义左滑显示编辑按钮
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:@"删除"    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                                NSLog(@"删除");
                                                                                
                                                                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
                                                                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                                    
                                                                                    LZCartModel *model = [self.dataArray objectAtIndex:indexPath.row];
                                                                                    
                                                                                    [self.dataArray removeObjectAtIndex:indexPath.row];
                                                                                    //    删除
                                                                                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                                                    
                                                                                    //判断删除的商品是否已选择
                                                                                    if ([self.selectedArray containsObject:model]) {
                                                                                        //从已选中删除,重新计算价格
                                                                                        [self.selectedArray removeObject:model];
                                                                                        [self countPrice];
                                                                                    }
                                                                                    
                                                                                    if (self.selectedArray.count == self.dataArray.count) {
                                                                                        self.allSellectedButton.selected = YES;
                                                                                    } else {
                                                                                        self.allSellectedButton.selected = NO;
                                                                                    }
                                                                                    
                                                                                    if (self.dataArray.count == 0) {
                                                                                        [self changeView];
                                                                                    }
                                                                                    
                                                                                    //如果删除的时候数据紊乱,可延迟0.5s刷新一下
                                                                                    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
                                                                                    
                                                                                }];
                                                                                
                                                                                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                                                                                
                                                                                [alert addAction:okAction];
                                                                                [alert addAction:cancel];
                                                                                [self presentViewController:alert animated:YES completion:nil];

                                                                            }];
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                             NSLog(@"收藏");
                                                                             
                                                                         }];
    rowActionSec.backgroundColor = UIColorFromRGB(0xaf0e1d);//[UIColor colorWithHexString:@"0f3822"];
    rowAction.backgroundColor =  UIColorFromRGB(0xd9d9d9);//[UIColor colorWithHexString:@"d9d9d9"];
    
    //NSArray *arr = @[rowActionSec,rowAction];
    NSArray *arr = @[rowActionSec];
    return arr;
}



- (void)reloadTable {
    [self.myTableView reloadData];
}
#pragma mark -- 页面按钮点击事件

#pragma mark --- 全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (LZCartModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        
        for (LZCartModel *model in self.dataArray) {
            model.select = YES;
            [self.selectedArray addObject:model];
        }
    }
    
    [self.myTableView reloadData];
    [self countPrice];
}
#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
    if (self.selectedArray.count > 0) {
        for (LZCartModel *model in self.selectedArray) {
            NSLog(@"选择的商品>>%@>>>%ld",model,(long)model.number);
        }
    } else {
        NSLog(@"你还没有选择任何商品");
    }
    
}

#pragma mark --- action
-(void) actonShop
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@"1"}];
}



#pragma mark  --- 网络通讯
//- (void)loadData {
//    //[self creatData];
//    //[self changeView];
//}

-(void) loadData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLorderCartList];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (operation.tag == 1000)
     {
        //self.dataArray = operation.jsonResult.rows;
        
    
        [self.dataArray removeAllObjects];
        

        NSArray *arr = operation.jsonResult.rows;
        if (arr)
         {
            for (int i = 0; i < [arr count]; i++) {
                NSDictionary *dic = arr[i];
                LZCartModel *model = [[LZCartModel alloc]init];
                
                model.cartIdStr = [NSString stringWithFormat:@"%@", dic[@"cartId"]];
                model.skuCodeStr = [NSString stringWithFormat:@"%@", dic[@"skuCode"]];
                model.nameStr = dic[@"goodsName"];
                model.price =  [NSString stringWithFormat:@"¥%@", dic[@"price"]];
                float fmarketPrice = [dic[@"marketPrice"] floatValue];
                if (fmarketPrice > 0.00)
                 {
                    model.price =  [NSString stringWithFormat:@"¥%@", dic[@"marketPrice"]];
                 }
                model.number =  [dic[@"num"] intValue];
                model.imageStr =  dic[@"goodsUrl"];
                //model.dateStr = @"2016.02.18";
                model.sizeStr = [NSString stringWithFormat:@"%@", dic[@"skuDesc"]];//@"18*20cm";
                
                [self.dataArray addObject:model];
            }
         }
        
        
        [self changeView];
        
     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}


@end

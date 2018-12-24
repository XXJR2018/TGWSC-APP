//
//  TabViewController_4.m
//  XXJR
//
//  Created by xxjr03 on 2018/12/4.
//  Copyright © 2018 Cary. All rights reserved.
//

#import "TabViewController_4.h"

#import "UserInfoViewController.h"

#import "JXButton.h"


@interface TabViewController_4 ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *_headImgView;
    UILabel *_phoneLabel;
    
    UIImageView *_orderImgView;
    UILabel *_dfkNumLabel;
    UILabel *_dfhNumLabel;
    UILabel *_yfhNumLabel;
    UILabel *_tkNumLabel;
    
    UILabel *_balanceNumLabel;  //余额
    UILabel *_pointsNumLabel;   // 积分
    UILabel *_couponNumLabel;   // 优惠券
    UILabel *_collectNumLabel;   // 收藏
    UIButton *_couponBtn;   //优惠券按钮
    
    
}

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIView *headView;

@property(nonatomic, strong)UIView *footView;
@end

@implementation TabViewController_4

#pragma mark-- 刷新用户数据更新用户信息显示
-(void)changeUserInfo{
    if ([CommonInfo userInfo].count == 0) {
        return;
    }
    NSDictionary *dic = [CommonInfo userInfo];
    //头像
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"headImgUrl"]].length > 0) {
        [_headImgView sd_setImageWithURL:[dic objectForKey:@"headImgUrl"] placeholderImage:[UIImage imageNamed:@"Tab_4-2"]];
    }else{
        _headImgView.image = [UIImage imageNamed:@"Tab_4-2"];
    }
    //电话
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"telephone"]].length == 11) {
        _phoneLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"telephone"]];
    }else{
        _phoneLabel.text = @"请登录";
    }
    //余额
//    if ([[dic objectForKey:@""] intValue] > 0) {
//        _balanceNumLabel.text  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"telephone"]];
//    }else{
//        _balanceNumLabel.text = @"";
//    }
//    //积分
//    if ([[dic objectForKey:@""] intValue] > 0) {
//        _pointsNumLabel.text  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"telephone"]];
//    }else{
//        _pointsNumLabel.text = @"";
//    }
//    //优惠券
//    if ([[dic objectForKey:@""] intValue] > 0) {
//        _couponNumLabel.text  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"telephone"]];
//    }else{
//        _couponNumLabel.text = @"";
//    }
//    //收藏
//    if ([[dic objectForKey:@""] intValue] > 0) {
//        _collectNumLabel.text  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"telephone"]];
//    }else{
//        _collectNumLabel.text = @"";
//    }
    //优惠券按钮
    if ([[dic objectForKey:@""] intValue] > 0) {
        [_couponBtn setImage:[UIImage imageNamed:@"Tab_4-18"] forState:UIControlStateNormal];
    }else{
        [_couponBtn setImage:[UIImage imageNamed:@"Tab_4-14"] forState:UIControlStateNormal];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人中心"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人中心"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hideBackButton = YES;
    [self layoutNaviBarViewWithTitle:@"个人中心"];
    
    [self layoutUI];
    
    [self changeUserInfo];
    // 更新用户头像等信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo) name:@"NotificationChangeUserInfo" object:nil];
}

-(void)layoutUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight)];
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //发送通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];

    self.headView = [UIView new];
    self.footView = [UIView new];
    [self.tableView setTableHeaderView:self.headView];
    [self.tableView setTableFooterView:self.footView];
    
    [self headViewUI];
    [self footViewUI];
}

#pragma mark--headViewUI
-(void)headViewUI{
    
    UIImageView *backdropImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 275 * ScaleSize)];
    [self.headView addSubview:backdropImgView];
    backdropImgView.image = [UIImage imageNamed:@"Tab_4-1"];
    backdropImgView.userInteractionEnabled = YES;
    
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, NavHeight - 20, 50 * ScaleSize, 50 * ScaleSize)];
    [backdropImgView addSubview:_headImgView];
    _headImgView.image = [UIImage imageNamed:@"Tab_4-2"];
    _headImgView.userInteractionEnabled = YES;
    // 没这句话倒不了角
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = 50 * ScaleSize/2;
    
    
    UITapGestureRecognizer * gestureSearch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImg)];
    gestureSearch.numberOfTapsRequired  = 1;
    [_headImgView addGestureRecognizer:gestureSearch];
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImgView.frame) + 15, CGRectGetMidY(_headImgView.frame) - 10, 100, 20)];
    [backdropImgView addSubview:_phoneLabel];
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    _phoneLabel.text = @"请登录";
    
    UIButton *userInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backdropImgView.frame) - 40, CGRectGetMidY(_headImgView.frame) - 10, 10, 20)];
    [backdropImgView addSubview:userInfoBtn];
    [userInfoBtn setImage:[UIImage imageNamed:@"Tab_4-3"] forState:UIControlStateNormal];
    [userInfoBtn addTarget:self action:@selector(userInfo) forControlEvents:UIControlEventTouchUpInside];
    
    _orderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImgView.frame) + 10, SCREEN_WIDTH, 168 * ScaleSize)];
    [backdropImgView addSubview:_orderImgView];
    _orderImgView.image = [UIImage imageNamed:@"Tab_4-4"];
    backdropImgView.userInteractionEnabled = YES;
    

    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(backdropImgView.frame));
    
    [self orderViewUI];
}

#pragma mark 订单按钮布局
-(void)orderViewUI{
    [_orderImgView removeAllSubviews];
 
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 340 * ScaleSize)/2 + 15, 25 * ScaleSize, 150, 30)];
    [_orderImgView addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.text = @"我的订单";
    titleLabel.textColor = [ResourceManager color_1];
    
    UIButton *allOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(_orderImgView.frame.size.width - 100 - (SCREEN_WIDTH - 340 * ScaleSize)/2, 25 * ScaleSize, 100, 30)];
    [_orderImgView addSubview:allOrderBtn];
    allOrderBtn.tag = 99;
    allOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [allOrderBtn setTitle:@"全部订单 >" forState:UIControlStateNormal];
    [allOrderBtn setTitleColor:UIColorFromRGB(0x85775b) forState:UIControlStateNormal];
    [allOrderBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat btnLeft = (SCREEN_WIDTH - 310 * ScaleSize)/2;
    CGFloat btnWidth = (310 * ScaleSize)/4;
    NSArray *imgArr = @[@"Tab_4-5",@"Tab_4-6",@"Tab_4-7",@"Tab_4-8"];
    NSArray *titleArr = @[@"待付款",@"待发货",@"已发货",@"退款/售后"];
    for (int i = 0; i < 4; i ++) {
        JXButton *orderBtn = [[JXButton alloc]initWithFrame:CGRectMake(btnLeft + btnWidth * i, CGRectGetMaxY(titleLabel.frame) + 10, btnWidth, btnWidth)];
        [_orderImgView addSubview:orderBtn];
        orderBtn.tag = i + 100;
        [orderBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
        [orderBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [orderBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [orderBtn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        if (i == 0) {
            _dfkNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 33, 5, 12, 12)];
            [orderBtn addSubview:_dfkNumLabel];
            _dfkNumLabel.clipsToBounds = YES;
            _dfkNumLabel.layer.cornerRadius = 12/2;
            _dfkNumLabel.backgroundColor = [UIColor redColor];
            _dfkNumLabel.textColor = [UIColor whiteColor];
            _dfkNumLabel.textAlignment = NSTextAlignmentCenter;
            _dfkNumLabel.font = [UIFont systemFontOfSize:8];
            _dfkNumLabel.text = @"1";
        }else if (i == 1) {
            _dfhNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 33, 5, 12, 12)];
            [orderBtn addSubview:_dfhNumLabel];
            _dfhNumLabel.clipsToBounds = YES;
            _dfhNumLabel.layer.cornerRadius = 12/2;
            _dfhNumLabel.backgroundColor = [UIColor redColor];
            _dfhNumLabel.textColor = [UIColor whiteColor];
            _dfhNumLabel.textAlignment = NSTextAlignmentCenter;
            _dfhNumLabel.font = [UIFont systemFontOfSize:8];
            _dfhNumLabel.text = @"99";
        }else if (i == 2) {
            _yfhNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 33, 5, 12, 12)];
            [orderBtn addSubview:_yfhNumLabel];
            _yfhNumLabel.clipsToBounds = YES;
            _yfhNumLabel.layer.cornerRadius = 12/2;
            _yfhNumLabel.backgroundColor = [UIColor redColor];
            _yfhNumLabel.textColor = [UIColor whiteColor];
            _yfhNumLabel.textAlignment = NSTextAlignmentCenter;
            _yfhNumLabel.font = [UIFont systemFontOfSize:8];
            _yfhNumLabel.text = @"21";
        }else if (i == 3) {
            _tkNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 33, 5, 12, 12)];
            [orderBtn addSubview:_tkNumLabel];
            _tkNumLabel.clipsToBounds = YES;
            _tkNumLabel.layer.cornerRadius = 12/2;
            _tkNumLabel.backgroundColor = [UIColor redColor];
            _tkNumLabel.textColor = [UIColor whiteColor];
            _tkNumLabel.textAlignment = NSTextAlignmentCenter;
            _tkNumLabel.font = [UIFont systemFontOfSize:8];
            _tkNumLabel.text = @"10";
        }
    }
    
    
}


#pragma mark--footViewUI
-(void)footViewUI{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7)];
    [self.footView addSubview:view];
    view.backgroundColor = [ResourceManager viewBackgroundColor];
    
    CGFloat btnWidth = SCREEN_WIDTH/4;
    CGFloat currentHeight = 0;
    NSArray *imgArr = @[@"Tab_4-12",@"Tab_4-13",@"Tab_4-14",@"Tab_4-15",@"Tab_4-16",@"Tab_4-17"];
    NSArray *titleArr = @[@"我的余额",@"我的积分",@"优惠券",@"我的收藏",@"地址管理",@"客服中心"];
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 4; j ++) {
            if (i * 4 + j < imgArr.count) {
                if (i * 4 + j == 2) {
                    _couponBtn = [[JXButton alloc]initWithFrame:CGRectMake(btnWidth * j, btnWidth * i + 20 * (i + 1), btnWidth, btnWidth)];
                    [self.footView addSubview:_couponBtn];
                    _couponBtn.tag = i * 4 + j;
                    [_couponBtn addTarget:self action:@selector(functTouch:) forControlEvents:UIControlEventTouchUpInside];
                    [_couponBtn setTitle:titleArr[i * 4 + j] forState:UIControlStateNormal];
                    [_couponBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
                    [_couponBtn setImage:[UIImage imageNamed:imgArr[i * 4 + j]] forState:UIControlStateNormal];
                    
                    _couponNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnWidth - 20, btnWidth, 15)];
                    [_couponBtn addSubview:_couponNumLabel];
                    _couponNumLabel.textAlignment = NSTextAlignmentCenter;
                    _couponNumLabel.textColor = [ResourceManager mainColor];
                    _couponNumLabel.font = [UIFont systemFontOfSize:12];
                    _couponNumLabel.text = @"2";
                }else{
                    JXButton *functBtn = [[JXButton alloc]initWithFrame:CGRectMake(btnWidth * j, btnWidth * i + 20 * (i + 1), btnWidth, btnWidth)];
                    [self.footView addSubview:functBtn];
                    functBtn.tag = i * 4 + j;
                    [functBtn addTarget:self action:@selector(functTouch:) forControlEvents:UIControlEventTouchUpInside];
                    [functBtn setTitle:titleArr[i * 4 + j] forState:UIControlStateNormal];
                    [functBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
                    [functBtn setImage:[UIImage imageNamed:imgArr[i * 4 + j]] forState:UIControlStateNormal];
                    
                    if (i * 4 + j == 0) {
                        _balanceNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnWidth - 20, btnWidth, 15)];
                        [functBtn addSubview:_balanceNumLabel];
                        _balanceNumLabel.textAlignment = NSTextAlignmentCenter;
                        _balanceNumLabel.textColor = [ResourceManager mainColor];
                        _balanceNumLabel.font = [UIFont systemFontOfSize:12];
                        _balanceNumLabel.text = @"200.00";
                    }else if (i * 4 + j == 1) {
                        _pointsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnWidth - 20, btnWidth, 15)];
                        [functBtn addSubview:_pointsNumLabel];
                        _pointsNumLabel.textAlignment = NSTextAlignmentCenter;
                        _pointsNumLabel.textColor = [ResourceManager mainColor];
                        _pointsNumLabel.font = [UIFont systemFontOfSize:12];
                        _pointsNumLabel.text = @"125";
                    }else if (i * 4 + j == 3) {
                        _collectNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnWidth - 20, btnWidth, 15)];
                        [functBtn addSubview:_collectNumLabel];
                        _collectNumLabel.textAlignment = NSTextAlignmentCenter;
                        _collectNumLabel.textColor = [ResourceManager mainColor];
                        _collectNumLabel.font = [UIFont systemFontOfSize:12];
                        _collectNumLabel.text = @"19";
                    }
                    currentHeight = CGRectGetMaxY(functBtn.frame);
                }
            }
        }
    }
    
    UIImageView *bannerImgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 338.5 * ScaleSize)/2, currentHeight + 10, 338.5 * ScaleSize, 78 * ScaleSize)];
    [_footView addSubview:bannerImgView];
    bannerImgView.image = [UIImage imageNamed:@"Tab_4-9"];
    bannerImgView.userInteractionEnabled = YES;
    
    self.footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(bannerImgView.frame) + 10);
    
}

-(void)userInfo{
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    UserInfoViewController *ctl = [[UserInfoViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark----订单按钮点击事件orderTouch
-(void)orderTouch:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 100:{
            
        }break;
        case 101:{
            
        }break;
        case 102:{
            
        }break;
        case 103:{
            
        }break;
        default:
            break;
    }
    
}

#pragma mark----funct底部功能按钮点击事件
-(void)functTouch:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 0:{
            
        }break;
        case 1:{
            
        }break;
        default:
            break;
    }
    
}

#pragma mark========  上传头像
-(void)uploadImg{
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            return;
        }
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.allowsEditing = YES;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                           UIImagePickerControllerSourceTypeCamera];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [self.navigationController presentViewController:pickerController animated:YES completion:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            return;
        }
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.editing=YES;
        pickerController.delegate=self;
        pickerController.allowsEditing=YES;
        pickerController.navigationBar.translucent=NO;   //去除毛玻璃效果
        pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.navigationBar.tintColor = [ResourceManager mainColor];
        [self.navigationController presentViewController:pickerController animated:YES completion:nil];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];

    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];

    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate
/**
 *  解决取消按钮点击不灵敏问题
 */
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11){
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]){
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
            // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
            if (obj.frame.size.width < 42){
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}
#pragma mark -
#pragma mark UIImagePickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
#define dataSize 1024.0f
#define imageSize CGSizeMake(600.0f, 600.0f)
    //先把原图保存到图片库
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    }
    //获取用户选取的图片并转换成NSData
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //缩小图片的size
    image = [self imageByRedraw:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    if (imageData){
        self.imageData = imageData;
        // 上传
        [self upLoadImgData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  截图
 *  @return UIImage
 */
- (UIImage *)imageByRedraw:(UIImage *)image
{
    if (image.size.width == image.size.height)
    {
        UIGraphicsBeginImageContext(imageSize);
        CGRect rect = CGRectZero;
        rect.size = imageSize;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        CGFloat ratio = image.size.width / image.size.height;
        CGSize size = CGSizeZero;
        
        if (image.size.width > imageSize.width)
        {
            size.width = imageSize.width;
            size.height = size.width / ratio;
        }
        else if (image.size.height > imageSize.height)
        {
            size.height = imageSize.height;
            size.width = size.height * ratio;
        }
        else
        {
            size.width = image.size.width;
            size.height = image.size.height;
        }
        //这里的size是最终获取到的图片的大小
        UIGraphicsBeginImageContext(imageSize);
        CGRect rect = CGRectZero;
        rect.size = imageSize;
        //先填充整个图片区域的颜色为黑色
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
        rect.origin = CGPointMake((imageSize.width - size.width)/2, (imageSize.height - size.height)/2);
        rect.size = size;
        //画图
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

-(void)upLoadImgData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"headImg";
    params[@"signId"] = [CommonInfo signId];
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"tgwscIOS-%@",currentVersion];
    params[@"appVersion"] = versionStr;
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[PDAPI getSendFileAPI] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([(NSDictionary *)json objectForKey:@"success"]) {
            [MBProgressHUD showSuccessWithStatus:@"上传成功" toView:self.view];
            [DDGSetting sharedSettings].accountNeedRefresh = YES;
            NSDictionary *dic = [(NSDictionary *)json objectForKey:@"attr"];
            NSString *imgUrlStr = [dic objectForKey:@"url"];
            [self uploadHeadImgUrl:imgUrlStr];
        }else{
            [MBProgressHUD showErrorWithStatus:[(NSDictionary *)json objectForKey:@"message"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}

//图片提交到数据库
-(void)uploadHeadImgUrl:(NSString *)imgUrlStr{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/info/changeCustInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:@{@"headImgUrl":imgUrlStr} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      //上传成功展示新头像
                                                                                      [_headImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
                                                                                      //发送通知更新用户信息
                                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}



-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

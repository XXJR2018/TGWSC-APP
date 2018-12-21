//
//  ShopDetailVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/21.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ShopDetailVC.h"
#import <AVFoundation/AVFoundation.h>
#import "TSVideoPlayback.h"

@interface ShopDetailVC ()<TSVideoPlaybackDelegate>
{
}

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer
@property (nonatomic,assign) int type;  // 0  图片，  1  视频和图片混合
@property (nonatomic,strong) TSVideoPlayback *video;

@end

@implementation ShopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"商品详情"];
    
    [self initialControlUnit];
}

#pragma mark  --- 
-(void)initialControlUnit
{
    int iTopY = 40;
    iTopY = NavHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.video = [[TSVideoPlayback alloc] initWithFrame:CGRectMake(0, iTopY, self.view.frame.size.width, 300) ];
    self.video.delegate = self;
    self.type = 0;
    if (self.type == 1)
     {
        self.title = @"纯图片详情";
        [self.video setWithIsVideo:TSDETAILTYPEIMAGE andDataArray:[self imgArray]];
     }
    else{
        self.title = @"视频图片详情";
        [self.video setWithIsVideo:TSDETAILTYPEVIDEO andDataArray:[self bannerArray]];
    }
    [self.view addSubview:self.video];
    
    
    //UIView *viewTest = [UIView alloc] initWithFrame:CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
}

-(NSArray *)bannerArray
{
    return @[
             @"http://img.ptocool.com/video/2018-06-30_RGq4iDnu.mov",
             @"http://img.ptocool.com/3332-1518523974126-29",
             @"http://img.ptocool.com/3332-1518523974125-28",
             @"http://img.ptocool.com/3332-1518523974125-27",
             @"http://img.ptocool.com/3332-1518523974124-26"];
}
-(NSArray *)imgArray
{
    return @[
             @"http://img.ptocool.com/3332-1518523974126-29",
             @"http://img.ptocool.com/3332-1518523974125-28",
             @"http://img.ptocool.com/3332-1518523974125-27",
             @"http://img.ptocool.com/3332-1518523974124-26"];
}



//清除缓存必须写
-(void)dealloc
{
    [self.video clearCache];
}


#pragma mark - delegate
//TSVideoPlaybackDelegate
-(void)videoView:(TSVideoPlayback *)view didSelectItemAtIndexPath:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
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

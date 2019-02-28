//
//  ShowBannerJpegView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/28.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "ShowBannerJpegView.h"


@interface ShowBannerJpegView ()<UIScrollViewDelegate>
{
    UIScrollView * scrolView;
    UILabel  *labelIndex;
    
    NSArray *arrImg;
}


@end


@implementation ShowBannerJpegView
{
    int iCurNO;
}



-(ShowBannerJpegView*) initWithArrImg:(NSArray *)arr   withNo:(int) iNo
{
    self =  [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    arrImg = arr;
    
    iCurNO = iNo;
    
    [self drawUI];
    
    return self;
}

-(void) drawUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.9];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionClose)];
    gesture.numberOfTapsRequired  = 1;
    [self addGestureRecognizer:gesture];
    
    labelIndex = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 20)];
    [self addSubview:labelIndex];
    labelIndex.textColor = [UIColor whiteColor];
    labelIndex.font = [UIFont systemFontOfSize:14];
    labelIndex.textAlignment = NSTextAlignmentCenter;
    
    scrolView = [[UIScrollView alloc]init];
    scrolView.pagingEnabled  = YES;
    scrolView.delegate = self;
    scrolView.showsVerticalScrollIndicator = NO;
    scrolView.showsHorizontalScrollIndicator = NO;
    scrolView.userInteractionEnabled = YES;
    
    scrolView.alwaysBounceVertical = NO;
    scrolView.alwaysBounceHorizontal = NO;
    
    [self addSubview:scrolView];
    scrolView.frame = CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_WIDTH);
    scrolView.backgroundColor = [UIColor whiteColor];
    
    
    for (int i = 0; i < arrImg.count; i ++)
     {
        
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        
        //int iBetwwen = 20;
        //UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH + iBetwwen, 0, SCREEN_WIDTH - 2*iBetwwen, SCREEN_WIDTH - 2*iBetwwen)];
        
        img.userInteractionEnabled = YES;
        
        [img sd_setImageWithURL:[NSURL URLWithString:arrImg[i]] ];
        [scrolView addSubview:img];
     }
    
    scrolView.contentSize = CGSizeMake(arrImg.count*SCREEN_WIDTH, 0);
    
    labelIndex.text = [NSString stringWithFormat:@"%d/%d",(int)iCurNO,(int)arrImg.count];
    
    if (iCurNO > 1)
     {
        [scrolView setContentOffset:CGPointMake((iCurNO-1)*SCREEN_WIDTH,0) animated:YES];
     }
    
    
}


#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.bounds.size.width;
    iCurNO = (int)index+1;
    
    //self.indexLab.hidden = NO;
    labelIndex.text = [NSString stringWithFormat:@"%d/%d",(int)index+1,(int)arrImg.count];
    
}

#pragma mark  ---  action
-(void) actionClose
{
    [self removeAllSubviews];
    [self removeFromSuperview];
    self.hidden = YES;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

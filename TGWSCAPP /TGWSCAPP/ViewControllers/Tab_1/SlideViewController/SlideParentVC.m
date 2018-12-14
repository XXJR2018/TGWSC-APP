//
//  SlideParentVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/13.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SlideParentVC.h"
#import "SlideSub1.h"
#import "SlideSub1.h"

@interface SlideParentVC ()

@end

@implementation SlideParentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
}

#pragma mark --- 布局UI
// view 已经布局其 Subviews
- (void)viewDidLayoutSubviews {
    NSLog(@"%s", __FUNCTION__);
    [super viewDidLayoutSubviews];
    
    // update by baicai
    NSLog(@"CkViewController  frame:%f", self.view.frame.size.height);
    self.view.backgroundColor = [UIColor colorWithRed:(arc4random()%255 / 255.0) green:(arc4random()%255 / 255.0) blue:(arc4random()%255 / 255.0) alpha:1];
    
    
    UILabel *viewTail = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, 100, 18)];
    [self.view addSubview:viewTail];
    viewTail.backgroundColor = [UIColor yellowColor];
    viewTail.textColor = [UIColor blueColor];
    viewTail.text = _slideModel.strSlideName;
}

@end

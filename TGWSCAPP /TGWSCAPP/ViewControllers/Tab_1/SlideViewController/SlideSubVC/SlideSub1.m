//
//  SlideSub1.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SlideSub1.h"

@interface SlideSub1 ()

@end

@implementation SlideSub1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSLog(@"SlideSub1  frame:%f", self.view.frame.size.height);
}


#pragma mark --- 布局UI
// view 已经布局其 Subviews
- (void)viewDidLayoutSubviews
{
    NSLog(@"SlideSub1  frame:%f", self.view.frame.size.height);
    
    
    UILabel *viewTail = [[UILabel alloc] initWithFrame:CGRectMake(200, self.view.frame.size.height - 20, 100, 18)];
    [self.view addSubview:viewTail];
    viewTail.backgroundColor = [UIColor yellowColor];
    viewTail.textColor = [UIColor blueColor];
    viewTail.text = _slideModel.strSlideName;
}

@end

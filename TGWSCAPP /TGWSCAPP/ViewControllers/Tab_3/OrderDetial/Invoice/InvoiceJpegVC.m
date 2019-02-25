//
//  InvoiceJpegVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/13.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "InvoiceJpegVC.h"
#import <Photos/Photos.h>
@interface InvoiceJpegVC ()

@end

@implementation InvoiceJpegVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"发票"];
    
    [self layoutUI];
}

-(void)layoutUI{
    UIImageView *invoiceImgView = [[UIImageView alloc]init];
    [self.view addSubview:invoiceImgView];
    invoiceImgView.backgroundColor = [UIColor whiteColor];
    [invoiceImgView sd_setImageWithURL:[NSURL URLWithString:self.invoiceImgUrl]];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.invoiceImgUrl]];
    UIImage *image = [UIImage imageWithData:data];
    invoiceImgView.frame =CGRectMake( 20, NavHeight + 10, SCREEN_WIDTH - 40, image.size.height/image.size.width * (SCREEN_WIDTH - 40));

    UIButton *saveImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(invoiceImgView.frame) + 20, SCREEN_WIDTH - 80, 50)];
    [self.view addSubview:saveImgBtn];
    saveImgBtn.backgroundColor = UIColorFromRGB(0xCFA971);
    saveImgBtn.layer.cornerRadius = 50/2;
    saveImgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveImgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveImgBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [saveImgBtn addTarget:self action:@selector(saveImg) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark======保存图片到系统相册
-(void)saveImg{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.invoiceImgUrl]];
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

//保存图片回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error) {
        NSString *message = [NSString stringWithFormat:@"保存图片失败,失败原因：%@",error];
        [MBProgressHUD showErrorWithStatus:message toView:self.view];
    }else{
        [MBProgressHUD showSuccessWithStatus:@"图片已成功保存到相册" toView:self.view];
    }
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

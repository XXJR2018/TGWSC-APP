//
//  LZCartTableViewCell.m
//  LZCartViewController
//
//  Created by LQQ on 16/5/18.
//  Copyright © 2016年 LQQ. All rights reserved.
//  https://github.com/LQQZYY/CartDemo
//  http://blog.csdn.net/lqq200912408
//  QQ交流: 302934443

#import "LZCartTableViewCell.h"
#import "LZConfigFile.h"
#import "LZCartModel.h"

@interface LZCartTableViewCell ()
{
    LZNumberChangedBlock numberAddBlock;
    LZNumberChangedBlock numberCutBlock;
    LZCellSelectedBlock cellSelectedBlock;
}
//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;
//显示照片
@property (nonatomic,retain) UIImageView *lzImageView;
//商品名
@property (nonatomic,retain) UILabel *nameLabel;
//尺寸
@property (nonatomic,retain) UILabel *sizeLabel;
//时间
@property (nonatomic,retain) UILabel *dateLabel;
//价格
@property (nonatomic,retain) UILabel *priceLabel;
//原价格
@property (nonatomic,retain) UILabel *marketPriceLabel;
//数量
@property (nonatomic,retain)UILabel *numberLabel;

@end

@implementation LZCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LZColorFromRGB(245, 246, 248);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}
#pragma mark - public method
- (void)reloadDataWithModel:(LZCartModel*)model {
    
    //self.lzImageView.image = model.image;
    [self.lzImageView setImageWithURL:[NSURL URLWithString:model.imageStr]];
    self.nameLabel.text = model.nameStr;
    self.priceLabel.text = model.price;
    self.dateLabel.text = model.dateStr;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)model.number];
    self.sizeLabel.text = model.sizeStr;
    self.selectBtn.selected = model.select;
    
}

- (void)numberAddWithBlock:(LZNumberChangedBlock)block {
    numberAddBlock = block;
}

- (void)numberCutWithBlock:(LZNumberChangedBlock)block {
    numberCutBlock = block;
}

- (void)cellSelectedWithBlock:(LZCellSelectedBlock)block {
    cellSelectedBlock = block;
}
#pragma mark - 重写setter方法
- (void)setLzNumber:(NSInteger)lzNumber {
    _lzNumber = lzNumber;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)lzNumber];
}

- (void)setLzSelected:(BOOL)lzSelected {
    _lzSelected = lzSelected;
    self.selectBtn.selected = lzSelected;
}
#pragma mark - 按钮点击方法
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (cellSelectedBlock) {
        cellSelectedBlock(button.selected);
    }
}

- (void)addBtnClick:(UIButton*)button {
    
    NSInteger count = [self.numberLabel.text integerValue];
    count++;
    
    if (numberAddBlock) {
        numberAddBlock(count);
    }
}

- (void)cutBtnClick:(UIButton*)button {
    NSInteger count = [self.numberLabel.text integerValue];
    count--;
    if(count <= 0){
        return ;
    }

    if (numberCutBlock) {
        numberCutBlock(count);
    }
}
#pragma mark - 布局主视图
-(void)setupMainView {
    self.backgroundColor = [UIColor whiteColor];
    
    //背景框
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(10, 5, LZSCREEN_WIDTH - 20, lz_CartRowHeight - 10);
    //bgView.frame = CGRectMake(0, 0, LZSCREEN_WIDTH, lz_CartRowHeight);
    bgView.backgroundColor = [UIColor whiteColor];
    //bgView.layer.borderColor = LZColorFromHex(0xEEEEEE).CGColor;
    //bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.center = CGPointMake(20, bgView.height/2.0);
    selectBtn.bounds = CGRectMake(0, 0, 30, 30);
    [selectBtn setImage:[UIImage imageNamed:lz_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:lz_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.frame = CGRectMake(selectBtn.right + 5, 5, bgView.height - 10, bgView.height - 10);
    //imageBgView.backgroundColor = LZColorFromHex(0xF3F3F3);
    [bgView addSubview:imageBgView];
    
    //显示照片
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"default_pic_1"];
    imageView.frame = CGRectMake(imageBgView.left + 5, imageBgView.top + 5, imageBgView.width - 10, imageBgView.height - 10);
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imageView];
    self.lzImageView = imageView;
    
    CGFloat width = (bgView.width - imageBgView.right - 30);
    //商品名
    UILabel* nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(imageBgView.right + 10, 10, width, 25);
    nameLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //尺寸
    UILabel* sizeLabel = [[UILabel alloc]init];
    sizeLabel.frame = CGRectMake(nameLabel.left, nameLabel.bottom , width, 20);
    sizeLabel.textColor = LZColorFromRGB(132, 132, 132);
    sizeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:sizeLabel];
    self.sizeLabel = sizeLabel;
    
    //时间
//    UILabel* dateLabel = [[UILabel alloc]init];
//    dateLabel.frame = CGRectMake(nameLabel.left, sizeLabel.bottom , width, 20);
//    dateLabel.font = [UIFont systemFontOfSize:10];
//    dateLabel.textColor = LZColorFromRGB(132, 132, 132);
//    [bgView addSubview:dateLabel];
//    self.dateLabel = dateLabel;
    
    //价格
    UILabel* priceFHLabel = [[UILabel alloc]init];
    priceFHLabel.frame = CGRectMake(nameLabel.left, sizeLabel.bottom+5 , width, 20);
    priceFHLabel.font = [UIFont boldSystemFontOfSize:16];
    priceFHLabel.textColor = [ResourceManager priceColor];
    [bgView addSubview:priceFHLabel];
    priceFHLabel.text = @"¥";

    
    UILabel* priceLabel = [[UILabel alloc]init];
    priceLabel.frame = CGRectMake(nameLabel.left+12, sizeLabel.bottom+5 , width/2, 20);
    priceLabel.font = [UIFont boldSystemFontOfSize:16];
    priceLabel.textColor = [ResourceManager priceColor];

    [bgView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(bgView.width - 35, bgView.height - 35, 25, 25);
//    [addBtn setImage:[UIImage imageNamed:@"cart_addBtn_nomal"] forState:UIControlStateNormal];
//    [addBtn setImage:[UIImage imageNamed:@"cart_addBtn_highlight"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    addBtn.borderColor = [ResourceManager lightGrayColor];
    addBtn.borderWidth = 1;
    [bgView addSubview:addBtn];
    
    //数量显示
    UILabel* numberLabel = [[UILabel alloc]init];
    numberLabel.frame = CGRectMake(addBtn.left - 31, addBtn.top, 32, 25);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"1";
    numberLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberLabel];
    numberLabel.borderColor = [ResourceManager lightGrayColor];
    numberLabel.borderWidth = 1;
    self.numberLabel = numberLabel;
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBtn.frame = CGRectMake(numberLabel.left - 24, addBtn.top, 25, 25);
//    [cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_nomal"] forState:UIControlStateNormal];
//    [cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_highlight"] forState:UIControlStateHighlighted];
    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cutBtn];
    [cutBtn setTitle:@"—" forState:UIControlStateNormal];
    [cutBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    cutBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    cutBtn.borderColor = [ResourceManager lightGrayColor];
    cutBtn.borderWidth = 1;
    
    //加入分割线
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(10, lz_CartRowHeight-1, SCREEN_WIDTH-20, 1)];
    [self addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
}

@end

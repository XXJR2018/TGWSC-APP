//
//  BalanceViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "BalanceViewCell.h"


@interface BalanceViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabrl;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *orderNumber;

@property (strong, nonatomic) IBOutlet UILabel *changeNumLabel;

@end

@implementation BalanceViewCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self removeAllSubviews];
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.balanceType == 100) {
        [self xfmxUI];
    }else if (self.balanceType == 101) {
        [self lqjlUI];
    }else if (self.balanceType == 102) {
        [self gqjlUI];
    }
   
}

-(void)xfmxUI{
    
    _titleLabrl = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 250, 20)];
    [self addSubview:_titleLabrl];
    _titleLabrl.font = [UIFont systemFontOfSize:14];
    _titleLabrl.textColor = [ResourceManager color_1];
    _titleLabrl.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"recordDesc"]];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 250, 20)];
    [self addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [ResourceManager color_6];
    _timeLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"createTime"]];
    
    _orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 250, 20)];
    [self addSubview:_orderNumber];
    _orderNumber.font = [UIFont systemFontOfSize:12];
    _orderNumber.textColor = [ResourceManager color_6];
    _orderNumber.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"orderNo"]];
    
    _changeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 125, 20, 100, 20)];
    [self addSubview:_changeNumLabel];
    _changeNumLabel.font = [UIFont systemFontOfSize:14];
    _changeNumLabel.textColor = [ResourceManager color_1];
    _changeNumLabel.textAlignment = NSTextAlignmentRight;
    _changeNumLabel.text = [NSString stringWithFormat:@"-%@",[_dataDicionary objectForKey:@"amount"]];
    
    UIImageView *arrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 20 + (20 - 16)/2, 9, 16)];
    [self addSubview:arrowImgView];
    arrowImgView.image = [UIImage imageNamed:@"arrow_right"];
}

-(void)lqjlUI{
    _titleLabrl = [[UILabel alloc]init];
    _timeLabel = [[UILabel alloc]init];
    _changeNumLabel = [[UILabel alloc]init];
    _orderNumber = nil;
    
    NSArray *labelArr = @[_titleLabrl,_timeLabel,_changeNumLabel];
    NSArray *titleArr = @[[_dataDicionary objectForKey:@"ymdCreateTime"],[_dataDicionary objectForKey:@"validEndDate"],[_dataDicionary objectForKey:@"amount"]];
    for (int i = 0;  i < titleArr.count; i++) {
        UILabel *label = labelArr[i];
        label.frame = CGRectMake(10 + (SCREEN_WIDTH - 20)/3 * i, 0, (SCREEN_WIDTH - 20)/3, 50);
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [ResourceManager color_1];
        label.text = [NSString stringWithFormat:@"%@",titleArr[i]];
        if (i == 0) {
            label.textAlignment = NSTextAlignmentLeft;
        }else if (i == 1) {
            label.textAlignment = NSTextAlignmentCenter;
        }else{
            label.textAlignment = NSTextAlignmentRight;
        }
    }
}

-(void)gqjlUI{
    _titleLabrl = [[UILabel alloc]init];
    _timeLabel = [[UILabel alloc]init];
    _changeNumLabel = nil;
    _orderNumber = nil;
    
    NSArray *labelArr = @[_titleLabrl,_timeLabel];
    NSArray *titleArr = @[[_dataDicionary objectForKey:@"createTime"],[_dataDicionary objectForKey:@"amount"]];
    for (int i = 0;  i < titleArr.count; i++) {
        UILabel *label = labelArr[i];
        label.frame = CGRectMake(10 + (SCREEN_WIDTH - 20)/2 * i, 0, (SCREEN_WIDTH - 20)/2, 50);
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [ResourceManager color_1];
        label.text = [NSString stringWithFormat:@"%@",titleArr[i]];
        if (i == 0) {
            label.textAlignment = NSTextAlignmentLeft;
        }else{
            label.textAlignment = NSTextAlignmentRight;
        }
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

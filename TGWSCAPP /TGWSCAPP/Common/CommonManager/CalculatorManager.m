//
//  CalculatorManager.m
//  IncomeCalculator
//
//  Created by Cary on 15/6/2.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "CalculatorManager.h"

static CalculatorManager *manager;

@implementation CalculatorManager

+(CalculatorManager *)shareManager{
    if (!manager) {
        manager = [[CalculatorManager alloc] init];
    }
    return manager;
}

-(ResultModel *)model{
    if ( !_model) {
        _model = [[ResultModel alloc] init];
    }
    return _model;
}


#pragma mark ====
+(ResultModel *)calculateIncome:(int)money periodcount:(int)periodcount periodnum:(int)periodnum interestRate:(CGFloat)rate calculateModel:(CalculateMode)mode withList:(BOOL)list{
    
    [CalculatorManager shareManager];
    manager.san_invest_money = money;
    manager.san_rate = rate;
    manager.periodcount = periodcount;
    manager.periodnum = periodnum;
    manager.withListData = list;
    
    return [[CalculatorManager shareManager] calculate:mode];
}

+(CalculateMode)calculateMode:(NSString *)paybackType;{
    if ([paybackType isEqualToString:@"一次付清"]) {
        return CalculateModePayInFull;
    }else if ([paybackType isEqualToString:@"先息后本"]){
        return CalculateModeInterestAndPrincipal;
    }else if ([paybackType isEqualToString:@"等额本息"]){
        return CalculateModeEqualityPrincipalAndInterest;
    }else if ([paybackType isEqualToString:@"等额本金"]){
        return CalculateModeEqualityPrincipal;
    }
    
    return CalculateModePayInFull;
}

-(ResultModel *)calculate:(CalculateMode)mode{
    switch (mode) {
        case CalculateModePayInFull:
            // 一次付清
            // 返回应收利息
            return [self payInFull];
            break;
        case CalculateModeInterestAndPrincipal:
            // 先息后本
            // 返回ResultModel
            return [self interestAndPrincipal];
            break;
        case CalculateModeEqualityPrincipalAndInterest:
            // 等额本息
            // 返回ResultModel
            return [self equalityPrincipalAndInterest];
            break;
        case CalculateModeEqualityPrincipal:
            // 等额本金
            // 返回ResultModel
            return [self equalityPrincipal];
            break;
        default:
            break;
    }
    
    return nil;
}


#pragma mark ====
#pragma mark ==== 计算器
#pragma mark ====
// 一次还清
-(ResultModel *)payInFull{
    ResultModel *model = [[ResultModel alloc] init];
    model.interest = (float)_san_invest_money * _san_rate * (_periodcount * _periodnum / 30.f) / 12 / 100;
    model.principalAndInterest = model.interest + _san_invest_money;
    return model;
}

// 先息后本   每期利息 = 本金*期利率
-(ResultModel *)interestAndPrincipal{
    
    // 期收利息
    CGFloat monthInterest = (float)(_san_invest_money * _san_rate) / (360.f / _periodnum) / 100;
    // 总利息
    CGFloat totalInterest = monthInterest * _periodcount;
    // 待收本息
    float principalAndInterest = totalInterest + _san_invest_money;
    
    // 收益数据模型
    ResultModel *model = [[ResultModel alloc] init];
    model.interest = totalInterest;
    model.principalAndInterest = principalAndInterest;
    
    if (!manager.withListData) {
        return model;
    }
    
    // 利息、本金数据列表
    NSMutableArray *array = [NSMutableArray array];
    
    for(int i = 0 ; i <= _periodcount; i++){
        CGFloat daishoulixi;
        MonthCellModel *monthModel = [[MonthCellModel alloc] init];
        if(i == 0){
            monthModel.interest = 0.f;
            monthModel.lastInterest = 0.f;
            monthModel.lastPrincipalAndInterest = principalAndInterest;
        }else if(i == _periodcount){
            daishoulixi = totalInterest - monthInterest * i;
            
            monthModel.interest = monthInterest;
            //            monthModel.principal = principalAndInterest - monthInterest * i;
            monthModel.lastInterest = daishoulixi;
            monthModel.lastPrincipalAndInterest = 0.f;
        }else{
            daishoulixi = totalInterest - monthInterest * i;
            //            principalAndInterest = principalAndInterest - monthInterest * i;
            
            monthModel.interest = monthInterest;
            //            monthModel.principal = principalAndInterest;
            monthModel.lastInterest = daishoulixi;
            monthModel.lastPrincipalAndInterest = principalAndInterest - monthInterest * i;
        }
        
        [array addObject:monthModel];
    }
    
    model.resultArray = array;
    return model;
}

/*
 * 等额本息
 * 还款计算公式：每期还款额计算公式如下：   〔贷款本金×期利率×（1＋期利率）＾还款期数〕÷〔（1＋期利率）＾还款期数－1〕
 * 设贷款额为a，期利率为i，利率为I，还款期数为n，每期还款额为b，还款利息总和为Y
 * 第n期还款利息为：＝（a×i－b）×（1＋i）的（n－1）次方＋b
 */
-(ResultModel *)equalityPrincipalAndInterest{
    // 期利率
    double monthRate = (float)_san_rate/ (360.f / _periodnum) /100;
    // 期收本息
    
    double payMonth = (_san_invest_money * monthRate * pow(1 + monthRate,_periodcount))/(pow(1 + monthRate,_periodcount)-1);
    // 总本息
    double principalAndInterest = payMonth * _periodcount;
    // 总利息
    CGFloat totalInterest = principalAndInterest - _san_invest_money;
    
    // 收益数据模型
    ResultModel *model = [[ResultModel alloc] init];
    model.interest = totalInterest;
    model.principalAndInterest = principalAndInterest;
    
    if (!manager.withListData) {
        return model;
    }
    
    // 利息、本金数据列表
    NSMutableArray *array = [NSMutableArray array];
    
    for(int i=0;i <= _periodcount;i ++){
        MonthCellModel *monthModel = [[MonthCellModel alloc] init];
        if(i==0){
            monthModel.principal = 0.f;
            monthModel.interest = 0.f;
            monthModel.principalAndInterest = 0.f;
            monthModel.lastPrincipalAndInterest = principalAndInterest;
        }else{
            CGFloat interest = (_san_invest_money * monthRate- payMonth) * pow(1 + monthRate,i-1) + payMonth;
            CGFloat monthben = payMonth - interest;
            CGFloat daishou = principalAndInterest - payMonth * i;
            
            monthModel.principal = monthben;
            monthModel.interest = interest;
            monthModel.principalAndInterest = payMonth;
            monthModel.lastPrincipalAndInterest = daishou;
        }
        
        [array addObject:monthModel];
    }
    
    model.resultArray = array;
    return model;
}


/* 等额本金
 * 本金 = 总投资/总期数
 * 当期利息 =  （总投资-已还本金）*期利率
 * 设贷款额为a，期利率为i，利率为I，还款期数为n，an第n个期贷款剩余本金a1=a,a2=a-a/n,a3=a-2*a/n...以次类推 还款利息总和为Y
 * 支付利息Y=（n+1）*a*i/2
 * 还款总额=（n+1）*a*i/2+a
 */
-(ResultModel *)equalityPrincipal{
    // 期利率
    double monthRate = (float)_san_rate/ (360.f / _periodnum) /100;
    // 总本息
    double principalAndInterest = (_periodcount + 1) * _san_invest_money * monthRate / 2 + _san_invest_money;
    // 总利息
    double totalInterest = (_periodcount + 1) * _san_invest_money * monthRate / 2;
    
    
    // 收益数据模型
    ResultModel *model = [[ResultModel alloc] init];
    model.interest = totalInterest;
    model.principalAndInterest = principalAndInterest;
    
    if (!manager.withListData) {
        return model;
    }
    
    // 利息、本金数据列表
    NSMutableArray *array = [NSMutableArray array];
    
    CGFloat pay_already = 0.f;
    for(int i = 0;i <= _periodcount; i++){
        
        MonthCellModel *monthModel = [[MonthCellModel alloc] init];
        
        if(i == 0){
            monthModel.principal = 0.f;
            monthModel.interest = 0.f;
            monthModel.principalAndInterest = 0.f;
            monthModel.lastPrincipalAndInterest = principalAndInterest;
            
        }else{
            
            CGFloat month_ben = (float)_san_invest_money / _periodcount;
            CGFloat interest = (_san_invest_money - month_ben * (i - 1)) * monthRate;
            pay_already += month_ben + interest;
            CGFloat daishou = principalAndInterest - pay_already;
            
            monthModel.principal = month_ben;
            monthModel.interest = interest;
            monthModel.principalAndInterest = month_ben + interest;
            monthModel.lastPrincipalAndInterest = daishou;
        }
        
        [array addObject:monthModel];
    }
    
    model.resultArray = array;
    return model;
}


#pragma mark ==== Founction
-(CGFloat)formatMoney:(double)money{
    int temp = (int)round(money * 100);
    return (float)temp/100;
}

@end




@implementation ResultModel

@end

@implementation MonthCellModel
//+ (NSArray *)modelsWithDictArray:(NSArray *)dicts
//{
//    NSMutableArray *temp = [@[] mutableCopy];
//    for (MonthCellModel *model in dicts) {
////         MonthCellModel *model = [self modelWithDict:dict];
//        [temp addObject:model];
//    }
//    return [temp copy];
//
//}
//
//
//+ (instancetype)modelWithDict:(NSDictionary *)dict
//{
//    MonthCellModel *model = [[MonthCellModel alloc] init];
//    model.principalAndInterest = [[dict objectForKey:@"principalAndInterest"] floatValue];
//    model.interest = [[dict objectForKey:@"interest"] floatValue];
//    model.principal = [[dict objectForKey:@"principal"] floatValue];
//    model.latInterest = [[dict objectForKey:@"latInterest"] floatValue];
//    model.lastPrincipalAndInterest = [[dict objectForKey:@"lastPrincipalAndInterest"] floatValue];
//    return model;
//}
@end


//
//  CalculatorManager.h
//  IncomeCalculator
//
//  Created by Cary on 15/6/2.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>


#define KRate           @"rate"
//#define KTimeLenght     @"timelenght"
#define KRewardYield    @"rewardYield"
#define KPayBackType    @"paybackWay"
#define KPeriodnum      @"periodnum"
#define KPeriodcount    @"periodcount"


typedef enum : NSUInteger {
    
    CalculateModeInterestAndPrincipal,
    CalculateModeEqualityPrincipalAndInterest,
    CalculateModeEqualityPrincipal,
    CalculateModePayInFull,
} CalculateMode;


@interface ResultModel : NSObject


/*
 * MonthCellModel数据列表
 */
@property (nonatomic,strong) NSArray *resultArray;

/*
 * 利息合计
 */
@property (nonatomic,assign) float interest;

/*
 * 本息合计
 */
@property (nonatomic,assign) float principalAndInterest;

@end




@interface MonthCellModel : NSObject

/*
 * 月收本息
 */
@property (nonatomic,assign) float principalAndInterest;

/*
 * 月收利息
 */
@property (nonatomic,assign) float interest;

/*
 * 月收本金
 */
@property (nonatomic,assign) float principal;

/*
 * 待收利息
 */
@property (nonatomic,assign) float lastInterest;

/*
 * 待收本息
 */
@property (nonatomic,assign) float lastPrincipalAndInterest;

//+ (instancetype)modelWithDict:(NSDictionary *)dict;
//+ (NSArray *)modelsWithDictArray:(NSArray *)dicts;
@end



@interface CalculatorManager : NSObject

@property (nonatomic,strong) ResultModel *model;

@property (assign) int san_invest_money;

@property (assign) float san_rate;

@property (assign) int periodcount;

@property (assign) int periodnum;

@property (assign) BOOL withListData;


+(CalculatorManager *)shareManager;

// 一次还清
-(ResultModel *)payInFull;

/*
 *  
 */
+(ResultModel *)calculateIncome:(int)money  periodcount:(int)periodcount periodnum:(int)periodnum interestRate:(CGFloat)rate calculateModel:(CalculateMode)mode withList:(BOOL)list;

+(CalculateMode)calculateMode:(NSString *)paybackType;

@end




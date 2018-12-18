//
//  PDAPI.h
//  DDGProject
//
//  Created by Cary on 15/2/27.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

// 首页页面相关接口
// 获取首页菜单
static NSString *const kURLqueryCateList = @"appMall/category/queryCateList";
// 获取首页子Tab中各个页面的元素
static NSString *const kURLqueryShowTypeList = @"appMall//home/queryShowTypeList";



// 发送短信接口一（拿到SmsTokenID）
static NSString *const kDDGgetSmsToken = @"tgw/smsAction/getSmsToken/custLogin";
// 发送短信接口二（发送短信）
static NSString *const kDDGnologin = @"tgw/smsAction/nologin/custLogin";

//房价评估

// 所在城市列表
static NSString *const kDDGGetCheckAllCityAPIString = @"cpQuery/newAllCity";
// 查询此城市是否被支持  cpQuery/verifyCity
static NSString *const kDDGGetCheckCity = @"cpQuery/verifyCity";
// 选择物业查询楼盘
static NSString *const kDDGGetQueryEstateAPIString = @"cpQuery/app/xxjrNewEval/querySlEstate";
// 选择物业查询楼栋
static NSString *const kDDGGetQueryBuildingAPIString = @"cpQuery/app/xxjrNewEval/querySlBuilding";
// 选择物业查询单元号
static NSString *const kDDGGetQueryUnitAPIString = @"cpQuery/app/xxjrNewEval/queryYlUnit";
//static NSString *const kDDGGetQueryUnitAPIString = @"cpQuery/app/xxjrNewEval/queryYfzUnit";
// 选择物业查询门牌号
static NSString *const kDDGGetQueryHouseAPIString = @"cpQuery/app/xxjrNewEval/querySlHouse";
// 查询评估
static NSString *const kDDGGetSaveHouseEvalAPIString = @"cpQuery/app/xxjrNewEval/queryYlHouseEval";
// 查询云房评估
static NSString *const kDDGGetSaveYFHouseEvalAPIString = @"cpQuery/app/xxjrNewEval/queryHouseEval";
// 查询世联房价评估
static NSString *const kDDGGetSaveSLHouseEvalAPIString = @"cpQuery/app/xxjrNewEval/querySlHouseEval";
// 查询近期房屋成交(云房数据)
static NSString *const kDDGGetYfEstateCase = @"cpQuery/app/xxjrNewEval/queryYfEstateCase";
// 评估历史
static NSString *const kDDGGetHistoryRecordAPIString = @"cpQuery/app/xxjrNewEval/evalHouseHistory";
// 查询历史评估详情
static NSString *const kDDGGetHistoryRecordDetail = @"cpQuery/app/xxjrNewEval/evalDetail";
// 再次查询
static NSString *const kDDGGetqueryHistoryEval = @"cpQuery/app/xxjrNewEval/queryHistoryEval";


// 验证码登录获取验证码
static NSString *const kDDGGetNologinKjlogAPIString = @"xxcust/smsAction/newNologin/kjLogin";


/*!
 @brief 管理所有接口URL
 */
@interface PDAPI : NSObject

/*!
 @brief     服务器地址
 @return    base url string
 */
+ (NSString *)getBaseUrlString;


/*!
 @brief     服务器地址 （业务）
 @return    base url string
 */
+ (NSString *)getBusiUrlString;

/*!
 @brief     跳转h5路径
 @return    NSString
 */
+ (NSString *)WXSysRouteAPI;

#pragma mark === Function
/*!
 @brief     版本检测
 @return    NSString
 */
+ (NSString *)getCheckVersionAPI;

/*!
 @brief     上传材料、图片
 @return    NSString
 */
+ (NSString *)getSendFileAPI;

#pragma 征信查询
//征信查询
/*!
 @brief     登陆注册图片验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditAPI;
/*!
 @brief     注册第一步
 @return    NSString
 */
+ (NSString *)getCheckCreditRegAPI;
/*!
 @brief     注册第二步
 @return    NSString
 */
+ (NSString *)getCheckCreditRegSupplementInfoAPI;
/*!
 @brief     登陆
 @return    NSString
 */
+ (NSString *)getCheckCreditLoginAPI;
/*!
 @brief     注册验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditSendRegMsgAPI;
/*!
 @brief     问题验证问题
 @return    NSString
 */
+ (NSString *)getCheckCreditIdentityDataAPI;
/*!
 @brief     提交问题
 @return    NSString
 */
+ (NSString *)getCheckCreditQuestionDataAPI;
/*!
 @brief     用户列表
 @return    NSString
 */
+ (NSString *)getCheckCreditInitDataAPI;
/*!
 @brief     用户列表信息
 @return    NSString
 */
+ (NSString *)getCheckCreditReportListDataAPI;
/*!
 @brief     核对银行验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditReportAPI;
/*!
 @brief     信息列表
 @return    NSString
 */
+ (NSString *)getCheckCreditReportDataAPI;
/*!
 @brief     贷款记录明细
 @return    NSString
 */
+ (NSString *)getCheckCreditRecordDataAPI;
/*!
 @brief     查询记录明细
 @return    NSString
 */
+ (NSString *)getCheckQueryReocrdDataAPI;


//企业查询
/*!
 @brief     企业查询结果
 @return    NSString
 */
+ (NSString *)getCheckQueryDataAPI;
/*!
 @brief     查询结果详情
 @return    NSString
 */
+ (NSString *)getCheckQueryDetailDataAPI;
//失信人查询
/*!
 @brief     失信人查询结果
 @return    NSString
 */
+ (NSString *)getChecksSXRQueryDataAPI;
/*!
 @brief     失信人查询结果详情
 @return    NSString
 */
+ (NSString *)getChecksSXRDetailDataAPI;


#pragma mark 设置
/*!
 @brief  设置-更改绑定手机号
 @return    NSString
 */
+ (NSString *)userForceBindingWXAPI;
/*!
 @brief  设置-查询当前绑定微信
 @return    NSString
 */
+ (NSString *)userInfoBindingWXWXAPI;
/*!
 @brief   设置-修改密码
 @return    NSString
 */
+ (NSString *)userChangeLoginPwdAPI;


#pragma mark 登陆
/*!
 @brief    验证码登陆
 @return    NSString
 */
+ (NSString *)userKJLoginInfoAPI;

/*!
 @brief   微信登陆
 @return    NSString
 */
+ (NSString *)userWXLoginInfoAPI;

/*!
 @brief   获取用户信息，需要登录
 @return    NSString
 */
+ (NSString *)getUserBaseInfoAPI;




@end






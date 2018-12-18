//
//  PDAPI.m
//  DDGProject
//
//  Created by Cary on 15/2/27.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "PDAPI.h"

/*!
 @brief 基础API接口地址, 注意后面必须有/
 */

// 接口URL
static NSString *const kBaseURL = @"https://www.tiangouwo.com/";

#if PMHEnableSwitchURLGesture
/*!
 @brief 存储baseurl的key
 */
static NSString *const kBaseURLinUserDefaultsString     = @"URLinUserDefaultsString";
/*!
 @brief 存储统计url的key
 */
static NSString *const kStatURLinUserDefaultsString     = @"kStatURLinUserDefaultsString";


#endif
// 版本信息
static NSString *const kDDGUserBorrowVersionAPIString= @"fx/cust/app/upgradeInfo";

// 上传材料、头像
static NSString *const kDDGGetSendFileAPIString = @"busi/uploadAction/uploadFile";

// 查询用户信息
static NSString *const kDDGGetUserBaseInfoAPIString = @"fx/account/info/getCustInfo";


//征信查询
//图片验证码
static NSString *const kDDGGetCheckCreditAPIString = @"cpQuery/credit/page/viewImageStream";
//注册第一步
static NSString *const kDDGGetCheckCreditRegAPIString = @"cpQuery/credit/page/reg";
//注册第二步
static NSString *const kDDGGetCheckCreditRegSupplementAPIString = @"cpQuery/credit/page/regSupplementInfo";
// 登陆
static NSString *const kDDGGetCheckCreditLoginAPIString = @"cpQuery/credit/page/login";
//注册验证码
static NSString *const kDDGGetCheckCreditSendRegMsgAPIString = @"cpQuery/credit/page/sendRegMsg";
//问题验证问题
static NSString *const kDDGGetCheckCreditIdentityDataAPIString = @"cpQuery/credit/page/questionIdentityData";
//提交问题
static NSString *const kDDGGetCheckCreditQuestionAPIString = @"cpQuery/credit/page/submitQuestion";
//用户列表
static NSString *const kDDGGetCheckCreditInitDataAPIString = @"cpQuery/credit/page/initData";
//用户列表信息
static NSString *const kDDGGetCheckCreditReportListDataAPIString = @"cpQuery/credit/page/creditReportListData";

//核对银行验证码
static NSString *const kDDGGetCheckCreditReportAPIString = @"cpQuery/credit/page/creditReport";
//信息列表
static NSString *const kDDGGetCheckCreditReportDataAPIString = @"cpQuery/credit/page/creditReportData";
//贷款记录明细
static NSString *const kDDGGetCheckCreditRecordDataAPIString = @"cpQuery/credit/page/creditRecordData";
//查询记录明细
static NSString *const kDDGGetCheckQueryReocrdDataAPIString = @"cpQuery/credit/page/queryReocrdData";

//企业查询
//企业查询结果
static NSString *const kDDGGetCheckQueryDataAPIString = @"cpQuery/company/page/queryData";
//企业查询结果详情
static NSString *const kDDGGetCheckQueryDetailDataAPIString = @"cpQuery/company/page/detailData";

//失信人查询
// 失信人查询结果
static NSString *const kDDGGetCheckSXRQueryDataAPIString = @"cpQuery/lose/page/sxrQueryData";
// 失信人查询结果详情
static NSString *const kDDGGetCheckSXRDetailDataAPIString = @"cpQuery/lose/page/sxrDetailData";



//  设置-更改绑定手机号
static NSString *const kDDGUserForceBindingWXAPIString= @"xxcust/account/info/forceBindingWX";

// 设置-查询当前绑定微信
static NSString *const kDDGUserInfoBindingWXAPIString= @"xxcust/account/info/bindingWXNew";

// 设置-修改密码
static NSString *const kDDGUserChangeLoginPwdAPIString= @"xxcust/account/info/changeLoginPwd";

#pragma mark 登陆

// 验证码登陆
static NSString *const kDDGUserKJLoginAPIString= @"appMall/login/kjLogin";

// 微信登陆
static NSString *const kDDGUserWXLoginAPIString= @"fx/cust/app/wxLogin";

@implementation PDAPI

// 跳转微信端h5路径
+ (NSString *)WXSysRouteAPI{
#if DEBUG
//    return @"https://www.tiangouwo.com/";
    return @"http://192.168.10.182:3000/";   // 测试环境
    
#else
    return kBaseURL;
#endif
}

//服务器地址
+ (NSString *)getBaseUrlString{
#if DEBUG
//    return @"https://www.tiangouwo.com/";     //生产环境
//    return @"http://192.168.10.182/";        //测试环境
    return  @"http://192.168.10.132:9999/";        //方然青服务器
//    return @"http://192.168.10.129:82/";        //刘利伟服务器
//    return  @"http://192.168.10.130:9999/";     // 邹全洪
    
#else
    return kBaseURL;
#endif
}

+ (NSString *)getBusiUrlString
{
#if DEBUG
    //    return @"https://www.tiangouwo.com/";     //生产环境
    //    return @"http://192.168.10.182/";        //测试环境
    //    return @"http://192.168.10.129:82/";        //刘利伟服务器
    return  @"http://192.168.10.130:9999/";     // 邹全洪
    
#else
    return kBaseURL;
#endif
}

/*!
 @brief     获取完整api的url
 @param     urlString url的名称
 @return    NSString 完全的api
 */
+ (NSString *)getFullApi:(NSString *)urlString
{
#if PMHEnableSwitchURLGesture
    if (kEnableUrlVersion)
        return DDG_str(@"%@v%@/%@", [PDAPI getBaseUrlString], PDVersionString, urlString);
    else
        return DDG_str(@"%@%@", [PDAPI getBaseUrlString], urlString);
#else
    
    return DDG_str(@"%@%@", [PDAPI getBaseUrlString], urlString);
#endif
}

+ (void)setApp_Token:(NSString *)app_Token{
    if (app_Token && app_Token.length > 1) {
        [[NSUserDefaults standardUserDefaults] setObject:app_Token forKey:APPToken];
    }else
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:APPToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAppToken{
    NSString *app_token = [[NSUserDefaults standardUserDefaults] objectForKey:APPToken];
    if (!app_token) {
        return @"";
    }
    return app_token;
}

+ (NSString *)getAppTokenAdmin{
    NSString *app_token_admin = @"app_token=0&";
    if ([self getAppToken] && [[self getAppToken] length] > 1) {
        app_token_admin = [NSString stringWithFormat:@"app_token=%@/",[self getAppToken]];
    }
    return app_token_admin;
}



#pragma mark === Function
/*!
 @brief    版本检测
 @return    NSString
 */
+ (NSString *)getCheckVersionAPI{
    return [self getFullApi:kDDGUserBorrowVersionAPIString];
}

/*!
 @brief     上传材料/图片
 @return    NSString
 */
+ (NSString *)getSendFileAPI{
    return [self getFullApi:kDDGGetSendFileAPIString];
}

#pragma mark 征信
//征信查询
/*!
 @brief     登陆注册图片验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditAPI{
   return [self getFullApi:kDDGGetCheckCreditAPIString];
}
/*!
 @brief     注册第一步
 @return    NSString
 */
+ (NSString *)getCheckCreditRegAPI{
    return [self getFullApi:kDDGGetCheckCreditRegAPIString];
}
/*!
 @brief     注册第二步
 @return    NSString
 */
+ (NSString *)getCheckCreditRegSupplementInfoAPI{
    return [self getFullApi:kDDGGetCheckCreditRegSupplementAPIString];
}
/*!
 @brief     登陆
 @return    NSString
 */
+ (NSString *)getCheckCreditLoginAPI{
    return [self getFullApi:kDDGGetCheckCreditLoginAPIString];
}
/*!
 @brief     注册验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditSendRegMsgAPI{
    return [self getFullApi:kDDGGetCheckCreditSendRegMsgAPIString];
}
/*!
 @brief     问题验证问题
 @return    NSString
 */
+ (NSString *)getCheckCreditIdentityDataAPI{
    return [self getFullApi:kDDGGetCheckCreditIdentityDataAPIString];
}
/*!
 @brief     提交问题
 @return    NSString
 */
+ (NSString *)getCheckCreditQuestionDataAPI{
    return [self getFullApi:kDDGGetCheckCreditQuestionAPIString];
}
/*!
 @brief     用户列表
 @return    NSString
 */
+ (NSString *)getCheckCreditInitDataAPI{
    return [self getFullApi:kDDGGetCheckCreditInitDataAPIString];
}
/*!
 @brief     用户列表信息
 @return    NSString
 */
+ (NSString *)getCheckCreditReportListDataAPI{
    return [self getFullApi:kDDGGetCheckCreditReportListDataAPIString];
}

/*!
 @brief     核对银行验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditReportAPI{
    return [self getFullApi:kDDGGetCheckCreditReportAPIString];
}

/*!
 @brief     信息列表
 @return    NSString
 */
+ (NSString *)getCheckCreditReportDataAPI{
    return [self getFullApi:kDDGGetCheckCreditReportDataAPIString];
}
/*!
 @brief     贷款记录明细
 @return    NSString
 */
+ (NSString *)getCheckCreditRecordDataAPI{
    return [self getFullApi:kDDGGetCheckCreditRecordDataAPIString];
}
/*!
 @brief     查询记录明细
 @return    NSString
 */
+ (NSString *)getCheckQueryReocrdDataAPI{
    return [self getFullApi:kDDGGetCheckQueryReocrdDataAPIString];
}
//企业查询
/*!
 @brief     企业查询结果
 @return    NSString
 */
+ (NSString *)getCheckQueryDataAPI{
    return [self getFullApi:kDDGGetCheckQueryDataAPIString];
}

/*!
 @brief     查询结果详情
 @return    NSString
 */
+ (NSString *)getCheckQueryDetailDataAPI{
    return [self getFullApi:kDDGGetCheckQueryDetailDataAPIString];
}

//失信人查询
/*!
 @brief     失信人查询结果
 @return    NSString
 */
+ (NSString *)getChecksSXRQueryDataAPI{
    return [self getFullApi:kDDGGetCheckSXRQueryDataAPIString];
}
/*!
 @brief     失信人查询结果详情
 @return    NSString
 */
+ (NSString *)getChecksSXRDetailDataAPI{
    return [self getFullApi:kDDGGetCheckSXRDetailDataAPIString];
}

#pragma mark 登陆#pragma mark 登陆#pragma mark 登陆
/*!
 @brief  设置-更改绑定手机号
 @return    NSString
 */
+ (NSString *)userForceBindingWXAPI{
    return [self getFullApi:kDDGUserForceBindingWXAPIString];
}
/*!
 @brief  设置-查询当前绑定微信
 @return    NSString
 */
+ (NSString *)userInfoBindingWXWXAPI{
    return [self getFullApi:kDDGUserInfoBindingWXAPIString];
}
/*!
 @brief   设置-修改密码
 @return    NSString
 */
+ (NSString *)userChangeLoginPwdAPI{
    return [self getFullApi:kDDGUserChangeLoginPwdAPIString];
}


#pragma mark 登陆
/*!
 @brief   验证码登陆
 @return    NSString
 */
+ (NSString *)userKJLoginInfoAPI{
    return [self getFullApi:kDDGUserKJLoginAPIString];
}

/*!
 @brief   微信登陆
 @return    NSString
 */
+ (NSString *)userWXLoginInfoAPI{
    return [self getFullApi:kDDGUserWXLoginAPIString];
}
/*!
 @brief   获取用户信息，需要登录
 @return    NSString
 */
+ (NSString *)getUserBaseInfoAPI{
    return [self getFullApi:kDDGGetUserBaseInfoAPIString];
}








@end

//
//  PDAPI.h
//  DDGProject
//
//  Created by Cary on 15/2/27.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

// 发送登录短信接口一（拿到登录SmsTokenID）
static NSString *const kDDGgetSmsToken = @"appMall/smsSend/getSmsToken/kjLogin";
// 发送登录短信接口二（发送登录短信）
static NSString *const kDDGnologin = @"appMall/smsSend/nologin/kjLogin";
// 发送普通短信接口一（拿到SmsTokenID）  请求URL：/appMall/smsSend/getSmsToken/{type}
static NSString *const kDDGgetSmsTokenByType = @"appMall/smsSend/getSmsToken";
// 发送普通短信接口二（发送短信） 请求URL：/appMall/smsSend/login/{type}
static NSString *const kDDGnologinByType = @"appMall/smsSend/login";




#pragma mark --- 首页页面相关接口
// 获取首页菜单
static NSString *const kURLqueryCateList = @"appMall/category/queryCateList";
// 获取首页子Tab中各个页面的元素
static NSString *const kURLqueryShowTypeList = @"appMall/home/queryShowTypeList";


#pragma mark ---  商品详情页面相关接口
// 获取商品基本信息
static NSString *const kURLqueryGoodsBaseInfo = @"appMall/goods/queryGoodsBaseInfo";
// 获取商品的附加信息
static NSString *const kURLqueryGoodsDetailInfo = @"appMall/goods/queryGoodsDetailInfo";
// 查询商品SKU展示规格列表 （展示）
static NSString *const kURLquerySkuProList = @"appMall/sku/querySkuProList";
// 查询商品SKU所有列表
static NSString *const kURLquerySkuList = @"appMall/sku/querySkuList";
// 收藏商品，取消商品
static NSString *const kURLaddFavorite = @"appMall/account/cust/favorite/addFavorite";
// 查询更多商品 (按类型查)
static NSString *const kURLqueryTypeMoreInfoList = @"appMall/home/queryTypeMoreInfoList";
// 按名称和条件查询商品详情
static NSString *const kURLqueryGoodsByCondition = @"appMall/goods/queryGoodsByCondition";
// 搜索时，即时匹配的字符
static NSString *const kURLqueryGoodsKey = @"appMall/goodskey/queryGoodsKey";


#pragma mark ---- 购物车相关
//  购物车列表
static NSString *const kURLorderCartList = @"appMall/account/orderCart/list";
//  购物车面中，加入购物车
static NSString *const kURLorderCartAdd = @"appMall/account/orderCart/add";
//  修改购物车
static NSString *const kURLorderCartUpdate = @"appMall/account/orderCart/update";
//  删除购物车
static NSString *const kURLorderCartDelete = @"appMall/account/orderCart/delete";
// 购物车页面 的抬头
static NSString *const kURLgetSaleTitle = @"appMall/account/orderCart/getSaleTitle";


#pragma mark ---- 订单详情
//  商品详情页面中，立即购买获取订单详情， 需要调用此接口（相当于下单接口）
static NSString *const kURLsingleOrderInfo = @"appMall/account/commitOrder/singleOrderInfo";
//  购物车页面下单，获取订单详情
static NSString *const kURLbatchOrderInfo = @"appMall/account/commitOrder/batchOrderInfo";
//  提交订单，获取最重要的支付参数 (注意：如果是余额充足，并且选择余额支付， 提交订单后会直接成功)
static NSString *const kURLcommitOrder = @"appMall/account/commitOrder/commitOrder";
// 去支付
static NSString *const kURLgoPay = @"appMall/account/payOrder/goPay";


#pragma mark ---- 退款/售后
// 退款原因
static NSString *const kURLresionList = @"appMall/account/orderRefund/resionList";
// 退款商品列表
static NSString *const kURLrefundGoodsList = @"appMall/account/orderRefund/refundGoodsList";
// 退款商品(申请页面的展示)
static NSString *const kURLselectRefundGoods = @"appMall/account/orderRefund/selectRefundGoods";
// 退款申请
static NSString *const kURLapplyRefund = @"appMall/account/orderRefund/applyRefund";
// 退款/售后列表
static NSString *const kURLrefundList = @"appMall/account/orderRefund/list";
// 退款详情
static NSString *const kURLrefundDetailInfo = @"appMall/account/orderRefund/detailInfo";
// 取消申请
static NSString *const kURcancelApply = @"appMall/account/orderRefund/cancelApply";
// 保存退款物流信息
static NSString *const kURLsaveLogistics = @"appMall/account/orderRefund/saveLogistics";
// 退款详情
static NSString *const kURLqueryLogistics = @"account/orderRefund/queryLogistics";
// 删除订单
static NSString *const kURLdeleteOrder = @"appMall/account/myOrder/deleteOrder";
// 确认收货
static NSString *const kURLconfirmGoods = @"appMall/account/myOrder/confirmGoods";
// 修改地址
static NSString *const kURLupdateOrderAddr = @"appMall/account/myOrder/updateOrderAddr";
// 查询物流信息
static NSString *const kURLlogisticsInfo = @"appMall/account/myOrder/logisticsInfo";
// 查询物流详细信息
static NSString *const kURLlogisticsInfoDtl = @"appMall/account/myOrder/logisticsInfoDtl";
// 售后进度
static NSString *const kURLquerySaleSchedule = @"appMall/account/orderRefund/querySaleSchedule";






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






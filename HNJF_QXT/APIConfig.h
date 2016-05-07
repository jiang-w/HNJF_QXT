//
//  APIConfig.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/14.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h

#define PRODUCT_SERVER_URL                @"http://test.qi888.com"
//#define PRODUCT_SERVER_URL                @"https://www.qi888.com"
#define API_ERROR_DOMAIN                  @"com.qi888.api"

/* API */
// 登录
#define RDAPI_User_DoLogin                @"/app/token/init.html"
// 获取用户信息
#define RDAPI_Account_Basic               @"/app/user/accountInfo.html"
// 检查用户名
#define RDAPI_User_CheckUsernameAvailable @"/app/common/checkUser.html"
// 获取手机验证码
#define RDAPI_User_GetCode                @"/app/common/getCode.html"
// 注册
#define RDAPI_User_DoRegister             @"/app/common/doRegister.html"
// 更改密码
#define RDAPI_Account_ModifyPwd           @"/app/user/updatePwd.html"
// 首页图片
#define RDAPI_Index_Banner                @"/app/common/picIndex.html"
// 首页新手专享
#define RDAPI_Index_NewHand               @"/app/common/index.html"
// 首页高收益产品
#define RDAPI_Index_BorrowIndex           @"/app/common/borrowIndex.html"
// 高收益产品列表
#define RDAPI_Invest_InvestList           @"/app/invest/investList.html"
// 高收益产品明细
#define RDAPI_Invest_Detail               @"/app/invest/detail.html"
// 债权产品列表
#define RDAPI_Bond_List                   @"/app/bond/bondList.html"
// 检查验证码
#define RDAPI_User_CheckCode              @"/app/common/checkCode.html"

// respose code
#define kRdServiceNetworkingFailure       -1
#define kRdServiceResultBussinessError    0
#define kRdServiceResultSuccess           1
#define kRdServiceResultNoData            2
#define kRdServiceResultInvalidToken      4
#define kRdServiceResultTokenExpired      103


#endif /* APIConfig_h */

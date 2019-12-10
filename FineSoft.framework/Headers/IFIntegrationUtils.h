//
//  IFIntegrationUtils.h
//  IFWidget
//
//  Created by 魏阳露 on 15/6/23.
//  Copyright (c) 2015年 FineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

/**
 *  开放给客户的集成工具类
 */
@interface IFIntegrationUtils : NSObject

/**
 *  登录服务器
 *
 *  @param serverName 服务器名称
 *  @param serverUrl  服务器地址
 *  @param username   用户名
 *  @param password   密码
 *  @param others     其他参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)logInto:(NSString *) serverName serverUrl:(NSString *)serverUrl withUsername:(NSString *)username andPassword:(NSString *)password others:(NSDictionary *)others success:(void (^)(NSDictionary *userInfo))success failure:(void (^)(NSString *message))failure;


/**
 *  登录服务器
 *
 *  @param serverName 服务器名称
 *  @param serverUrl  服务器地址
 *  @param username   用户名
 *  @param password   密码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)logInto:(NSString *) serverName serverUrl:(NSString *)serverUrl withUsername:(NSString *)username andPassword:(NSString *)password success:(void (^)(NSDictionary *userInfo))success failure:(void (^)(NSString *message))failure;

+ (void)loadReportTree:(void (^)(NSMutableArray *reportsArray))success failure:(void (^)(NSString *message))failure;

/**
 *  得到已登录服务器的目录树节点
 *  @param success 成功回调，reportsArray为IFEntryNode数组
 *  @param failure 失败回调
 *  @param isObj 返回值是否是IFEntryNode对象，todo——后续版本会删除
 */
+ (void)loadReportTree:(void (^)(NSMutableArray *reportsArray))success failure:(void (^)(NSString *message))failure isObj:(BOOL) isObj;

/**
 *  所有收藏的报表
 *
 *  @param success 成功回调，favorites为IFEntryNode数组
 *  @param faliure 失败回调
 */
+ (void)favorites:(void (^)(NSMutableArray *favorites))success failure:(void (^)(NSString *message))failure;

/**
 *  登出
 */
+ (void) logOut;

/**
 *  创建需要的数据库表，主要用于使用离线功能
 */
+ (void) createTable;

/**
 *  修改密码
 *  @param oldPassword 旧密码
 *  @param newPassword 新密码
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void) changePassword:(NSString *) oldPassword newPassword:(NSString *) newPassword success:(void (^)()) success failure:(void (^)(NSString *message)) failure;

//当前登录的用户是否可以更改密码（非管理员并且是同步数据集/http认证/ldap认证时不支持更改密码）
+ (BOOL) canChangePassword;

/**
 *  获取用于推送的设备码
 */
+ (NSString *) deviceToken;

/**
 *  设置用于推送的设备码
 *  @param dt 设备码
 */
+ (void) setDeviceToken:(NSString *) dt;

//读取报表/目录的缩略图
+ (void) readEntryImage:(NSString *) entryId coverId:(NSString *) coverId sucess:(void (^)(UIImage *image)) success;

/**
 *  为离线填报保存服务器信息
    @param serverUrl 服务器地址
    @param username 用户名
    @param password 密码
 */
+ (void) cacheServer:(NSString *) serverName serverUrl:(NSString *) serverUrl username:(NSString *) username password:(NSString *) password;

/*
 * 下载并暂存单张模板
   @param reportPath 模板路径
   @param parameters 模板参数
   @param cacheName 暂存后的名字
   @param success 成功回调
   @param failure 失败回调
 */
+ (void) downloadAndCacheReport:(NSString *) reportPath parameters:(NSDictionary *) parameters cacheName:(NSString *) cacheName success:(void (^)())success failure:(void (^)(NSString *message))failure;

/**
   下载并暂存多张模板，需要提供每个模板的路径，参数和暂存后的名字，数组里包含NSDictionary对象
   @param reportsInfo 例如：
   [{reportPath:WorkBook1.cpt, cacheName:暂存1, parameters:{xx:2}}, {reportPath:WorkBook2.cpt, cacheName:暂存2, parameters:{xx:1}}, ...]
   @param complete 完成后回调，参数是下载过程中出错模板列表，包括出错的模板路径和错误信息。如果为空，说明全部下载成功
 */
+ (void) downloadAndCacheReports:(NSArray *) reportsInfo complete:(void (^)(NSArray *errorList)) complete;

@end

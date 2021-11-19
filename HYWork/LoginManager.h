//
//  LoginManager.h
//  HYWork
//
//  Created by information on 16/4/11.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "RequestHeader.h"
#import "WKHttpTool.h"

@interface LoginManager : NSObject

/// 用户登陆
/// @param url 请求地址
/// @param gh 工号
/// @param mm 密码
/// @param success 成功回调
/// @param fail 失败回调
+ (void)postJSONWithUrl:(NSString *)url gh:(NSString *)gh mm:(NSString *)mm success:(void(^)(id json))success fail:(void(^)(void))fail;

+ (void)checkVersionWithUrl:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)(void))fail;


/// 判断是否需要提醒
/// @param params 请求参数 - 工号
/// @param success 成功回调
/// @param fail 失败回调
+ (void)remaindMe:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)(void))fail;


/// 上传闪退日志
/// @param params 请求参数
/// @param success 成功回调
/// @param fail 失败回调
+ (void)crashLog:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)(void))fail;

@end

//
//  WKHttpTool.h
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface WKHttpTool : NSObject

/**
 发送一个POST请求
 
 @param url 请求路径
 @param params 请求参数
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)postWithUrl:(NSString *)url param:(NSDictionary *)param success:(void(^)(id responseObject))succes failure:(void(^)(NSError *error))failure;

/**
 发送一个GET请求
 
 @param url 请求路径
 @param params 请求参数
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


/// 发送一个GET请求,返回 text/plain
/// @param url 请求路径
/// @param params 请求参数
/// @param success 成功回调
/// @param failure 失败回调
+ (void)getWithURLAndResponseText:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;


/**
 图片上传 post请求

 @param url 请求地址
 @param params 请求参数
 @param formDataArray 图片数组
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end

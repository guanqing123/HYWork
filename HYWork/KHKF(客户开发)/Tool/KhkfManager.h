//
//  KhkfManager.h
//  HYWork
//
//  Created by information on 2017/7/21.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id json);
typedef void(^failBlock)();

#import "WKQdkh.h"

#import "WKTJZ5Param.h"
#import "WKTjz5.h"

#import "WKPhotoResult.h"
#import "WKQdkfParam.h"

#import "WKQdkhParam.h"

@interface KhkfManager : NSObject

/** 根据查询条件获取潜在客户列表 */
+ (void)getQzKhListByCondition:(NSDictionary *)params success:(successBlock)success fail:(failBlock)fail;

/** 根据序号删除潜在客户 */
+ (void)deleteQzkhByXh:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)())fail;


/**
 获取 统计组5 List

 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)getTjz5ByKhdm:(WKTJZ5Param *)params success:(void(^)(NSArray* xlArray))success fail:(void(^)())fail;


/**
 保存图片

 @param params 参数
 @param imageArray 图片数组
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)savePhoto:(NSDictionary *)params imageArray:(NSArray *)imageArray success:(void(^)(WKPhotoResult* photoResult))success failure:(void(^)())fail;


/**
 保存渠道客户

 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)saveQdkf:(WKQdkfParam *)params success:(void(^)(BOOL flag))success fail:(void(^)())fail;

+ (void)getQdkhBean:(WKQdkhParam *)params success:(void(^)(WKQdkh *qdkh))success fail:(void(^)())fail;

@end

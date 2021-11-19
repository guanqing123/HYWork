//
//  WKKQTool.h
//  HYWork
//
//  Created by information on 2021/4/8.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKKQTool : NSObject

/// 上报虚拟定位
/// @param vlDict 错误信息
/// @param success 成功回调
/// @param failure 失败回调
+ (void)postVirtualLocation:(NSDictionary *)vlDict success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;


/// 考勤提醒
/// @param kqtxDict 请求参数
/// @param success 成功回调
/// @param failure 失败回调
+ (void)remindKqtx:(NSDictionary *)kqtxDict success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

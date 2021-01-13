//
//  WKFunsTool.h
//  HYWork
//
//  Created by information on 2021/1/13.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WKHomeWorkResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKFunsTool : NSObject

/// 获取功能模块列表
/// @param success 成功回调
/// @param failure 失败回调
+ (void)getHomeWork:(void(^)(WKHomeWorkResult *result))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

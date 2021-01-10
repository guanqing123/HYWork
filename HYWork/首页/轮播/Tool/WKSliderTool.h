//
//  WKSliderTool.h
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKSliderResult.h"

#import "WKSliderListParam.h"
#import "WKSliderListResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKSliderTool : NSObject

/// 获取轮播详情
/// @param dict 请求参数
/// @param success 成功回调
/// @param failure 失败回调
+ (void)getSliderDetail:(NSDictionary *)dict success:(void(^)(WKSliderResult *result))success failure:(void(^)(NSError *error))failure;


/// 获取往期回顾
/// @param param 请求参数
/// @param success 成功回调
/// @param failure 失败回调
+ (void)getSliderList:(WKSliderListParam *)sliderListParam success:(void(^)(WKSliderListResult *result))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

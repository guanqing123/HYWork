//
//  WKHomeTool.h
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WKHomeSliderParam.h"
#import "WKHomeSliderResult.h"

#import "WKHomeNoticeParam.h"
#import "WKHomeNoticeResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKHomeTool : NSObject

/// 获取首页轮播
/// @param sliderParam 请求参数
/// @param success 成功回调
/// @param failure 失败回调
+ (void)getHomeSliders:(WKHomeSliderParam *)sliderParam success:(void(^)(WKHomeSliderResult *result))success failure:(void(^)(NSError *error))failure;


/// 获取首页通知
/// @param noticeParam 请求参数
/// @param success 成功回调
/// @param failure 失败回调
+ (void)getHomeNotices:(WKHomeNoticeParam *)noticeParam success:(void(^)(WKHomeNoticeResult *result))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

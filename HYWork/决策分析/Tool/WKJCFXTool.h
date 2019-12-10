//
//  WKJCFXTool.h
//  HYWork
//
//  Created by information on 2019/11/1.
//  Copyright © 2019 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKJCFXTool : NSObject


/// 决策分析单点登录
/// @param param 请求参数
/// @param success 成功回调
/// @param fail 失败回调
+ (void)jcfxsso:(NSDictionary *)param success:(void(^)(id json))success fail:(void(^)())fail;

@end

NS_ASSUME_NONNULL_END

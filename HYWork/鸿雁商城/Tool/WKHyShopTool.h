//
//  WKHyShopTool.h
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKHyShopTool : NSObject

/// 获取鸿雁商城sso
/// @param success 成功回调
/// @param failure 失败回调
+ (void)getHyShopAddress:(NSDictionary *)params success:(void(^)(id josn))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

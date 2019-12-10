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

@interface LoginManager : NSObject

+ (void)postJSONWithUrl:(NSString *)url gh:(NSString *)gh mm:(NSString *)mm success:(void(^)(id json))success fail:(void(^)())fail;

+ (void)checkVersionWithUrl:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)())fail;

@end

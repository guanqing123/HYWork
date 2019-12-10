//
//  XpssManager.h
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XpssManager : NSObject

+ (NSArray *)xpssWithDict:(NSDictionary *)dict;

+ (void)postJSONWithUrl:(NSString *)url loginName:(NSString *)name typeStr:(NSString *)type need_paginate:(NSString *)paginate page_number:(NSString *)number page_size:(NSString *)size cpdmStr:(NSString *)cpdm success:(void(^)(id json))success fail:(void(^)())fail;

@end

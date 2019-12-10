//
//  JdzpManager.h
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JdzpManager : NSObject

+ (NSArray *)jdzpWithDict:(NSDictionary *)dict;

+ (void)postJSONWithUrl:(NSString *)aUrl need_paginate:(NSString *)paginate page_number:(NSString *)number page_size:(NSString *)size success:(void (^)(id json))success fail:(void (^)())fail;

@end

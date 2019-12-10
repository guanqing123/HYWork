//
//  WKKhhfTool.h
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WKKhhfTableParam.h"
#import "WKKhhfTableResult.h"

@interface WKKhhfTool : NSObject

+ (void)getKhhfList:(WKKhhfTableParam *)khhfParam success:(void(^)(WKKhhfTableResult *result))success failure:(void(^)(NSError *error))failure;

@end

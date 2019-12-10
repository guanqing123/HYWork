//
//  WKAddressTool.h
//  HYWork
//
//  Created by information on 2018/5/17.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKAddressTool : NSObject

+ (void)getAddressList:(NSDictionary *)param success:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure;

@end

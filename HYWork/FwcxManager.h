//
//  FwcxManager.h
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id json);
typedef void(^FailBlock)();

@interface FwcxManager : NSObject

+ (void)getFwcxWithUrl:(NSString *)url params:(NSDictionary *)params success:(SuccessBlock)success fail:(FailBlock)fail;

@end

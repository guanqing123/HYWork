//
//  CjwtManager.h
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id json);
typedef void(^FailBlock)();

@interface CjwtManager : NSObject

+ (void)getCjwtWithUrl:(NSString *)url success:(SuccessBlock)success fail:(FailBlock)fail;

+ (NSMutableArray *)jsonArrayToModelArray:(NSArray *)array;

@end

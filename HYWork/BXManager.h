//
//  BXManager.h
//  HYWork
//
//  Created by information on 16/5/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id json);
typedef void(^FailBlock)();

@interface BXManager : NSObject

+ (void)getBxListWithEcologyid:(NSString *)ecologyId Success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock;

+ (NSArray *)getBxListWithArray:(NSArray *)array;

@end

//
//  TxlManager.h
//  HYWork
//
//  Created by information on 16/4/14.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id json);
typedef void (^FailBlock)();

@interface TxlManager : NSObject

+ (void)getEmpsInfoWithGh:(NSString *)gh Type:(NSString *)type Success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock;

+ (void)getEmpDetailWithGh:(NSString *)gh Success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock;

@end

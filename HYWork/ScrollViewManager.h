//
//  ScrollViewManager.h
//  HYWork
//
//  Created by information on 16/4/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock) (id json);
typedef void(^FailBlock)();

@interface ScrollViewManager : NSObject

+ (void)postJSONWithUrl:(NSString *)url Success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock;

@end

@interface ScrollViewModelList : NSObject

+ (NSMutableArray *)getModelList:(NSDictionary *)dict;

@end

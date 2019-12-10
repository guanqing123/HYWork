//
//  GyhyManager.h
//  HYWork
//
//  Created by information on 16/7/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id json);
typedef void(^FailBlock)();

@interface GyhyManager : NSObject

+ (void)getQygkWithUrl:(NSString *)url success:(SuccessBlock)success fail:(FailBlock)fail;

+ (void)getQyryListWithUrl:(NSString *)url params:(NSDictionary *)params success:(SuccessBlock)success fail:(FailBlock)fail;

+ (NSArray *)dictToQyryModelArray:(NSDictionary *)dict;

+ (void)getQyzzWithUrl:(NSString *)url success:(SuccessBlock)success fail:(FailBlock)fail;

@end

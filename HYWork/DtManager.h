//
//  DtManager.h
//  HYWork
//
//  Created by information on 16/3/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RequestData;

@interface DtManager : NSObject

+ (void)postJSONWithUrl:(NSString *) url RequestData:(RequestData *)requestData success:(void(^)(id json))success fail:(void(^)())fail;

@end

@interface ModelList : NSObject

@property (strong, nonatomic)  NSMutableArray *dataArray;

+ (instancetype)getModelList:(NSDictionary *)dict;

@end
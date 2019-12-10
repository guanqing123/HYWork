//
//  KqManager.h
//  HYWork
//
//  Created by information on 16/4/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KqManager : NSObject
//KQ1
+ (void)postJsonWithCityCode:(NSString *)cityCode gh:(NSString *)gh success:(void(^)(id json))success fail:(void(^)())fail;

//KQ2
+ (void)postJsonWithDid:(NSString *)did gh:(NSString *)gh sign:(NSString *)sign success:(void(^)(id json))success fail:(void(^)())fail;

@end


@interface ModelList : NSObject

@property (strong, nonatomic)  NSMutableArray *dataArray;

+ (instancetype)getModelList:(NSDictionary *)dict;

@end
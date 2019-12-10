//
//  BXGroup.h
//  HYWork
//
//  Created by information on 16/5/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGroup : NSObject

@property (nonatomic, copy) NSString *lb;

@property (nonatomic, copy) NSString *size;

/**
 *  数组中装的都是MJFriend模型
 */
@property (nonatomic, strong)  NSArray *items;

/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;

+ (instancetype)bxGroupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end

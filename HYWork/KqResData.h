//
//  KqResData.h
//  HYWork
//
//  Created by information on 16/4/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KqResData : NSObject

@property (nonatomic, assign, getter=isHasFence) BOOL hasFence;

@property (nonatomic, assign) BOOL kqtx;

/**
 *  打卡次数
 */
@property (nonatomic, assign) int checkInTimes;

@property (nonatomic, assign, getter=isHasDevice) BOOL hasDevice;

@property (nonatomic, strong)  NSMutableArray *regions;

@property (nonatomic, strong)  NSMutableArray *devices;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)kqResDataWithDict:(NSDictionary *)dict;

@end

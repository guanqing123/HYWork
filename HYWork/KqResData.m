//
//  KqResData.m
//  HYWork
//
//  Created by information on 16/4/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "KqResData.h"
#import "Region.h"

@implementation KqResData

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.hasFence = [dict[@"hasFence"] boolValue];
        self.checkInTimes = [dict[@"checkInTimes"] intValue];
        self.hasDevice = [dict[@"hasDevice"] boolValue];
        NSArray *dictArray = dict[@"fence"];
        if (![dictArray isKindOfClass:[NSNull class]]) {
            NSMutableArray *regionArray = [NSMutableArray array];
            for (NSDictionary *dict in dictArray) {
                Region *region = [Region regionWithDict:dict];
                [regionArray addObject:region];
            }
            self.regions = regionArray;
        }
        self.devices = dict[@"devices"];
    }
    return self;
}

+ (instancetype)kqResDataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

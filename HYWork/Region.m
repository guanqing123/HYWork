//
//  Region.m
//  HYWork
//
//  Created by information on 16/4/1.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "Region.h"

@implementation Region

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)regionWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

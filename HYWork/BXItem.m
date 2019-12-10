//
//  BXItem.m
//  HYWork
//
//  Created by information on 16/5/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BXItem.h"

@implementation BXItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)bxItemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

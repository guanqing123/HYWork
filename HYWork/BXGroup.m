//
//  BXGroup.m
//  HYWork
//
//  Created by information on 16/5/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BXGroup.h"
#import "BXItem.h"

@implementation BXGroup

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
        NSMutableArray *itmeArray = [NSMutableArray array];
        for (NSDictionary *dict in self.items) {
            BXItem *item = [BXItem bxItemWithDict:dict];
            [itmeArray addObject:item];
        }
        _items = itmeArray;
    }
    return self;
}

+ (instancetype)bxGroupWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

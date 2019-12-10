//
//  Group.m
//  HYWork
//
//  Created by information on 16/3/21.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "Group.h"
#import "Item.h"

@implementation Group

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.header = dict[@"header"];
        self.r = [dict[@"r"] floatValue];
        self.g = [dict[@"g"] floatValue];
        self.b = [dict[@"b"] floatValue];
        NSArray *dictArray = dict[@"items"];
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            Item *item = [Item itemWithDict:dict];
            [itemArray addObject:item];
        }
        self.items = itemArray;
    }
    return self;
}

+ (instancetype)groupWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

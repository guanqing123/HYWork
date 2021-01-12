//
//  WKFunsItemGroup.m
//  demo
//
//  Created by zhong on 17/1/16.
//  Copyright © 2017年 Xz Studio. All rights reserved.
//

#import "WKFunsItemGroup.h"

@implementation WKFunsItemGroup

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.type = dict[@"type"];
        NSArray *items = dict[@"items"];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:items.count];
        for (NSDictionary *itemDict in items) {
            WKFunsItem *item = [[WKFunsItem alloc] initWithDict:itemDict];
            [array addObject:item];
        }
        self.items = array;
    }
    return self;
}


@end

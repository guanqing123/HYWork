//
//  Html.m
//  HYWork
//
//  Created by information on 16/6/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "Html.h"

@implementation Html
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.html = dict[@"html"];
        self.title = dict[@"title"];
        self.ID = dict[@"id"];
    }
    return self;
}

+ (instancetype)htmlWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

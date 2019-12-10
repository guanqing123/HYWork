//
//  ScrollViewModel.m
//  HYWork
//
//  Created by information on 16/4/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "ScrollViewModel.h"

@implementation ScrollViewModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if ([[dict objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
        _imgUrl = @"";
    } else {
        _imgUrl = [dict objectForKey:@"path"];
    }
    if ([[dict objectForKey:@"content"] isKindOfClass:[NSNull class]]) {
        _content = @"";
    } else {
        _content = [dict objectForKey:@"content"];
    }
    return self;
}

+ (instancetype)scrollModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

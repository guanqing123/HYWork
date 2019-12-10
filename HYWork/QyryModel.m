//
//  QyryModel.m
//  HYWork
//
//  Created by information on 16/7/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "QyryModel.h"

@implementation QyryModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([[dict objectForKey:@"content"] isKindOfClass:[NSNull class]]) {
            _content = @"";
        }else{
            _content = [dict objectForKey:@"content"];
        }
        _honerId = [dict objectForKey:@"id"];
        
        _data = [dict objectForKey:@"honor_date"];
        
        _title = [dict objectForKey:@"introduction"];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

//
//  DtCellModel.m
//  HYWork
//
//  Created by information on 16/3/3.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DtCellModel.h"

@implementation DtCellModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([[dict objectForKey:@"img_url"] isKindOfClass:[NSNull class]]) {
            _imgUrl = @"";
        }else{
            _imgUrl = [dict objectForKey:@"img_url"];
        }
        
        _title = [dict objectForKey:@"title"];
        _time = [dict objectForKey:@"submit_date"];
        _source = [dict objectForKey:@"source"];
        _content = [dict objectForKey:@"content"];
        _idStr = [dict objectForKey:@"id"];
    }
    return self;
}

+ (instancetype)dtCellWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

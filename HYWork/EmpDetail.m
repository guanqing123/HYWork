//
//  EmpDetail.m
//  HYWork
//
//  Created by information on 16/4/19.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "EmpDetail.h"

@implementation EmpDetail

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        NSString *join = @",";
        NSRange range = [_bmzw rangeOfString:join];
        if (range.location == NSNotFound) {
            _zws = [NSArray arrayWithObject:_bmzw];
        }else{
            _zws = [_bmzw componentsSeparatedByString:@","];
        }
    }
    return self;
}

+ (instancetype)empDetailWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

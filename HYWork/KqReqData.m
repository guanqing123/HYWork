//
//  KqReqData.m
//  HYWork
//
//  Created by information on 16/4/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "KqReqData.h"

@implementation KqReqData

- (instancetype)initWithCityCode:(NSString *)citycode Gh:(NSString *)gh{
    if (self = [super init]) {
        self.citycode = citycode;
        self.gh = gh;
    }
    return self;
}

+ (instancetype)kqReqDataWithCityCode:(NSString *)citycode Gh:(NSString *)gh {
    return [[self alloc] initWithCityCode:citycode Gh:gh];
}

@end

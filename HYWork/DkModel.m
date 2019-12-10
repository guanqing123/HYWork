//
//  DkModel.m
//  HYWork
//
//  Created by information on 16/3/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DkModel.h"

@implementation DkModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _khdm = dict[@"HK_KHDM"];
        _khmc = dict[@"HK_KHMC"];
        _syhbbm = dict[@"HK_SYHBDM"];
        _dkdd = dict[@"HK_DKDD"];
        _hzdd = dict[@"HK_HZDD"];
        float je;
        je = [dict[@"HK_JE"] floatValue];
        _je = [NSString stringWithFormat:@"%.2f",je];
        _ck = dict[@"HK_CK"];
        _dkdw = dict[@"HK_DKDH"];
        _zt = dict[@"HK_ZT"];
        if ([dict[@"HK_YWY"] isKindOfClass:[NSNull class]]) {
            _ywy = @"";
        }else{
            _ywy = dict[@"HK_YWY"];
        }
        _jzrq = dict[@"HK_JZRQ"];
        if (![_ms isKindOfClass:[NSNull class]]) {
            _ms = dict[@"HK_MS"];
        }
        if ([dict[@"HK_BMMC"] isKindOfClass:[NSNull class]]) {
            _bmmc = @"";
        }else{
            _bmmc = dict[@"HK_BMMC"];
        }
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

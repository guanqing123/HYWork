//
//  RequestHeader.m
//  HYWork
//
//  Created by information on 16/3/3.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "RequestHeader.h"

@implementation RequestHeader

- (instancetype)initWithTrcode:(NSString *)trcode {
    if (self = [self init]) {
        self.trcode = trcode;
    }
    return self;
}

- (instancetype)initWithAppseq:(NSString *)appseq {
    if (self = [self init]) {
        self.appseq = appseq;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *trdate = [formatter stringFromDate:[NSDate date]];
        self.trdate = trdate;
        self.appseq = @"IOS";
    }
    return self;
}

@end

//
//  RjhBPC.m
//  HYWork
//
//  Created by information on 2017/6/7.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhBPC.h"

@implementation RjhBPC

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:@(_bpcId) forKey:@"bpcId"];
    [coder encodeObject:_khdm forKey:@"khdm"];
    [coder encodeObject:_khmc forKey:@"khmc"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.bpcId = [[decoder decodeObjectForKey:@"bpcId"] intValue];
        self.khdm = [decoder decodeObjectForKey:@"khdm"];
        self.khmc = [decoder decodeObjectForKey:@"khmc"];
    }
    return self;
}

@end

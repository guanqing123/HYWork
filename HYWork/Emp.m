//
//  Emp.m
//  HYWork
//
//  Created by information on 16/4/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "Emp.h"

@implementation Emp

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.bmbm forKey:@"bmbm"];
    [coder encodeObject:self.bmmc forKey:@"bmmc"];
    [coder encodeObject:self.ecologydeptid forKey:@"ecologydeptid"];
    [coder encodeObject:self.ecologyid forKey:@"ecologyid"];
    [coder encodeObject:self.ygbm forKey:@"ygbm"];
    [coder encodeObject:self.jzbmbm forKey:@"jzbmbm"];
    [coder encodeObject:self.mobile forKey:@"mobile"];
    [coder encodeObject:self.mobilecall forKey:@"mobilecall"];
    [coder encodeObject:self.oamm forKey:@"oamm"];
    [coder encodeObject:self.slave forKey:@"slave"];
    [coder encodeObject:self.status forKey:@"status"];
    [coder encodeObject:self.telephone forKey:@"telephone"];
    [coder encodeObject:self.ygxm forKey:@"ygxm"];
    [coder encodeObject:self.xzzj forKey:@"xzzj"];
    [coder encodeObject:self.frdz forKey:@"frdz"];
    [coder encodeObject:self.mm forKey:@"mm"];
    [coder encodeObject:self.token forKey:@"token"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.bmbm = [aDecoder decodeObjectForKey:@"bmbm"];
        self.bmmc = [aDecoder decodeObjectForKey:@"bmmc"];
        self.ecologydeptid = [aDecoder decodeObjectForKey:@"ecologydeptid"];
        self.ecologyid = [aDecoder decodeObjectForKey:@"ecologyid"];
        self.ygbm = [aDecoder decodeObjectForKey:@"ygbm"];
        self.jzbmbm = [aDecoder decodeObjectForKey:@"jzbmbm"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.mobilecall = [aDecoder decodeObjectForKey:@"mobilecall"];
        self.oamm = [aDecoder decodeObjectForKey:@"oamm"];
        self.slave = [aDecoder decodeObjectForKey:@"slave"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.telephone = [aDecoder decodeObjectForKey:@"telephone"];
        self.ygxm = [aDecoder decodeObjectForKey:@"ygxm"];
        self.xzzj = [aDecoder decodeObjectForKey:@"xzzj"];
        self.frdz = [aDecoder decodeObjectForKey:@"frdz"];
        self.mm = [aDecoder decodeObjectForKey:@"mm"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}

@end

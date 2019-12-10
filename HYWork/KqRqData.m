//
//  KqRqData.m
//  HYWork
//
//  Created by information on 16/4/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "KqRqData.h"

@implementation KqRqData

- (instancetype)initWithGh:(NSString *)gh did:(NSString *)did sign:(NSString *)sign {
    if (self = [super init]) {
        self.gh = gh;
        self.did = did;
        self.sign = sign;
    }
    return self;
}

+ (instancetype)kqRqDataWidthGh:(NSString *)gh did:(NSString *)did sign:(NSString *)sign {
    return [[self alloc] initWithGh:gh did:did sign:sign];
}

@end

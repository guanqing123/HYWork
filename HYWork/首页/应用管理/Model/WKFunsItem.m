//
//  WKFunsItem.m
//  HYWork
//
//  Created by information on 2021/1/13.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKFunsItem.h"

@implementation WKFunsItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.imageName = dict[@"imageName"];
        self.itemTitle = dict[@"itemTitle"];
    }
    return self;
}


@end

//
//  WKWorkType.m
//  HYWork
//
//  Created by information on 2018/11/12.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKWorkType.h"
#import "MJExtension.h"

@implementation WKWorkType

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"jobs" : [WKWork class]};
}

@end

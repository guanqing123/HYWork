//
//  WKCity.m
//  HYWork
//
//  Created by information on 2018/5/17.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKCity.h"
#import "MJExtension.h"
#import "WKDistrict.h"

@implementation WKCity

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"sub" : [WKDistrict class]};
}

@end

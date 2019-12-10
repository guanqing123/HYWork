//
//  WKProvince.m
//  HYWork
//
//  Created by information on 2018/5/17.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKProvince.h"
#import "MJExtension.h"
#import "WKCity.h"

@implementation WKProvince

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"sub" : [WKCity class]};
}

@end

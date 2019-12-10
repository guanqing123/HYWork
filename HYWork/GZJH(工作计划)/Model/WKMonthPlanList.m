//
//  WKMonthPlanList.m
//  HYWork
//
//  Created by information on 2019/8/22.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKMonthPlanList.h"
#import "MJExtension.h"

@implementation WKMonthPlanList

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": [WKMonthPlan class]};
}

@end

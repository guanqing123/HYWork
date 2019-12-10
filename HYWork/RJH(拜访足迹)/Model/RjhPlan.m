//
//  RjhPlan.m
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhPlan.h"
#import "MJExtension.h"

@implementation RjhPlan

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"imagesurl" : [Photo class],@"remarklist" : [RjhRemark class]};
}

@end

//
//  WKRankRelationship.m
//  HYWork
//
//  Created by information on 2019/8/21.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKRankRelationship.h"
#import "MJExtension.h"
#import "ZJXS.h"
#import "SJLD.h"

@implementation WKRankRelationship

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"zjxs": [ZJXS class], @"sjld": [SJLD class]};
}

@end

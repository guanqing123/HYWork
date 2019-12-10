//
//  WKRankRelationshipResult.m
//  HYWork
//
//  Created by information on 2019/8/21.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKRankRelationshipResult.h"
#import "MJExtension.h"

@implementation WKRankRelationshipResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"rankRelationship" : @"data"};
}

@end

//
//  WKRankRelationshipResult.h
//  HYWork
//
//  Created by information on 2019/8/21.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBaseAppResult.h"
#import "WKRankRelationship.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKRankRelationshipResult : WKBaseAppResult

@property (nonatomic, strong)  WKRankRelationship *rankRelationship;

@end

NS_ASSUME_NONNULL_END

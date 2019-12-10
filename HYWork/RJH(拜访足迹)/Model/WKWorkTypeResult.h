//
//  WKWorkTypeResult.h
//  HYWork
//
//  Created by information on 2018/11/12.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKBaseResult.h"
#import "WKWorkType.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKWorkTypeResult : WKBaseResult

@property (nonatomic, assign) int disabled;

@property (nonatomic, assign) int type;

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, strong)  NSArray *level2;

@end

NS_ASSUME_NONNULL_END

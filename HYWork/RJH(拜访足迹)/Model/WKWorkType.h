//
//  WKWorkType.h
//  HYWork
//
//  Created by information on 2018/11/12.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKWork.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKWorkType : NSObject

@property (nonatomic, assign) int levelType;

@property (nonatomic, copy) NSString *levelName;

@property (nonatomic, strong)  NSArray *jobs;

@end

NS_ASSUME_NONNULL_END

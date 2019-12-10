//
//  WKMonthPlanResult.h
//  HYWork
//
//  Created by information on 2019/8/22.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKBaseAppResult.h"
#import "WKMonthPlanList.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKMonthPlanResult : WKBaseAppResult

@property (nonatomic, strong)  WKMonthPlanList *data;

@end

NS_ASSUME_NONNULL_END

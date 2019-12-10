//
//  WeekFromMonthController.h
//  HYWork
//
//  Created by information on 16/6/8.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYConstans.h"

@interface WeekFromMonthController : UIViewController

/** 开始日期 */
@property (nonatomic, copy) NSString *beginDate;

/** 开始查询日期 */
@property (nonatomic, copy) NSString *beginSDate;

/** 结束日期-->预计完成日期 */
@property (nonatomic, copy) NSString *endDate;

/** 员工编码 */
@property (nonatomic, copy) NSString *ygbm;

/** 员工姓名 */
@property (nonatomic, copy) NSString *ygxm;

/**上级领导 */
@property (nonatomic, strong)  NSArray *sjld;

@property (nonatomic, assign) PlanOriginalType planOriginalType;

- (instancetype)initWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate planOriginalType:(PlanOriginalType)planOriginalType;

@end

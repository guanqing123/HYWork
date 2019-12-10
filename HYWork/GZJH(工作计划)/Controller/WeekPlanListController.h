//
//  WeekPlanListController.h
//  HYWork
//
//  Created by information on 16/6/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekPlanListController : UIViewController

/** 来源 */
@property (nonatomic, copy) NSString *lb;

/** 开始日期 */
@property (nonatomic, copy) NSString *beginDate;

/** 结束日期 */
@property (nonatomic, copy) NSString *endDate;

/** 开始查询日期 */
@property (nonatomic, copy) NSString *beginSDate;

/** 结束查询日期 */
@property (nonatomic, copy) NSString *endSDate;

/** 员工编码 */
@property (nonatomic, copy) NSString *ygbm;

/** 员工名称 */
@property (nonatomic, copy) NSString *ygxm;

/**上级领导 */
@property (nonatomic, strong)  NSArray *sjld;


- (instancetype)initWithLb:(NSString *)lb beginDate:(NSString *)beginDate endDate:(NSString *)endDate;

@end

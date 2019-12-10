//
//  WeekPlanDetailController.h
//  HYWork
//
//  Created by information on 16/5/26.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekPlan.h"
#import "LoadViewController.h"
@class WeekPlanDetailController;

@interface WeekPlanDetailController : UITableViewController

@property (nonatomic, strong)  WeekPlan *weekPlan;
@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, strong)  NSArray *sjld;

@property (nonatomic, copy) NSString *ygbm;

@property (nonatomic, copy) NSString *currentYgbm;

- (instancetype)initWithWeekPlan:(WeekPlan *)weekPlan beginDate:(NSString *)beginDate currentYgbm:(NSString *)currentYgbm;

@end

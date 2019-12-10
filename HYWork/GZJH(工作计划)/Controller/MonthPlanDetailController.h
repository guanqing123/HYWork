//
//  MonthPlanDetailController.h
//  HYWork
//
//  Created by information on 16/6/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthPlan.h"
#import "LoadViewController.h"

@class MonthPlanDetailController;

@interface MonthPlanDetailController : UITableViewController

@property (nonatomic, strong)  MonthPlan *monthPlan;

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, strong)  NSArray *sjld;

@property (nonatomic, copy) NSString *ygbm;

@property (nonatomic, copy) NSString *currentYgbm;

@property (nonatomic, copy) NSString *xzzj;

- (instancetype)initWithMonthPlan:(MonthPlan *)monthPlan beginDate:(NSString *)beginDate currentYgbm:(NSString *)currentYgbm;

@end

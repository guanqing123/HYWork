//
//  LYConstans.h
//  HYWork
//
//  Created by information on 16/5/17.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PlanOriginalTypeWeekFromMonth,
    PlanOriginalTypeMonthFromMonth,
    PlanOriginalTypeMonthFromYear
} PlanOriginalType;

extern NSString *kGzjhMenuBtnClick; // 工作计划menu按钮监听

extern NSString *kGzjhScrollViewMove; // 工作计划scroll移动

extern NSString *kBrowseCellClick;

// 周计划详细界面 1.从 WeekPlanController 过来的计划,返回WeekPlanController只需要返回一级就可以刷新了
             // 2.从 WeekPlanListCon
extern NSString *kWeekPlanRefreshing;

extern NSString *kMonthPlanRefreshing;

extern NSString *kZjxsCheckCellClick;

extern NSString *rjhBrowseCellClick;

extern NSString *rjhBrowseCellAddCommon;

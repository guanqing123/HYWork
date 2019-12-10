//
//  WKMonthPlanHeaderView.h
//  HYWork
//
//  Created by information on 2019/9/17.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKMonthPlan.h"

NS_ASSUME_NONNULL_BEGIN
@class WKMonthPlanHeaderView;
@protocol WKMonthPlanHeaderViewDelegate <NSObject>
@optional

/**
 点击合并展开按钮

 @param headerView 组头
 */
- (void)headerViewDidClickExpend:(WKMonthPlanHeaderView *)headerView;

/**
 点击工作计划详情

 @param headerView 组头
 */
- (void)headerViewDidClickDetail:(WKMonthPlanHeaderView *)headerView;


/**
 点击添加计划

 @param headerView 组头
 */
- (void)headerViewDidClickAdd:(WKMonthPlanHeaderView *)headerView;

@end

@interface WKMonthPlanHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong)  WKMonthPlan *monthPlan;

@property (nonatomic, weak) id<WKMonthPlanHeaderViewDelegate> delegate;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

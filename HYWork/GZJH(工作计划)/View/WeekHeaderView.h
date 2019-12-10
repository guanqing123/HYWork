//
//  WeekHeaderView.h
//  HYWork
//
//  Created by information on 16/5/17.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeekHeaderView;

typedef enum {
    GzjhPlanTypeWeek,
    GzjhPlanTypeMonth,
    GzjhPlanTypeYear
} GzjhPlanType;

@protocol weekHeaderViewDelegate <NSObject>
@optional
/**
 *  时间赋值好,开始加载数据
 */
- (void)weekHeaderFinishDateDidLoadTableData:(WeekHeaderView *)weekHeader;

/**
 *  点击取消按钮,要求控制器做什么事情
 */
- (void)weekHeaderDidClickCancelButtonLoadData:(WeekHeaderView *)weekHeader;

/**
 *  点击全选按钮,要求控制器做什么事情
 */
- (void)weekHeaderDidClickAllChooseButtonLoadData:(WeekHeaderView *)weekHeader;

@end

@interface WeekHeaderView : UIView

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, assign, getter=isEdit) BOOL edit;

+ (instancetype)headerView:(CGRect)frame;

- (void)fillBeginAndEndDateWithPickDate:(NSDate *)date gzjhPlanType:(GzjhPlanType)planType;

@property (nonatomic, assign) GzjhPlanType planType;

@property (nonatomic, weak) id<weekHeaderViewDelegate>  delegate;

@end

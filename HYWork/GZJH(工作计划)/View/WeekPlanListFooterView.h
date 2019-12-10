//
//  WeekPlanListFooterView.h
//  HYWork
//
//  Created by information on 16/6/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeekPlanListFooterView,DatePickerView;

@protocol WeekPlanListFooterViewDelegate <NSObject>

/** 点击开始日期按钮 */
- (void)weekPlanListFooterViewDidClickDateBtn:(WeekPlanListFooterView *)footerView;

/** 点击确定按钮 */
- (void)weekPlanListFooterViewDidClickSureBtn:(WeekPlanListFooterView *)footerView;

@end

@interface WeekPlanListFooterView : UIView

+ (instancetype)footerView;

/**
 *  开始日期
 */
@property (nonatomic, copy) NSString *beginDate;
/**
 *  结束日期
 */
@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, weak) id<WeekPlanListFooterViewDelegate>  delegate;

/** 日期选择器 */
@property (nonatomic, strong) DatePickerView  *datePickerView;
@property (nonatomic, strong)  UIView *cover;

@end

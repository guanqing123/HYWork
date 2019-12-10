//
//  WeekFromMonthFooterView.h
//  HYWork
//
//  Created by information on 16/6/8.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeekFromMonthFooterView,DatePickerView;

@protocol WeekFromMonthFooterViewDelegate <NSObject>

/** 点击开始日期按钮 */
- (void)WeekFromMonthFooterViewDidClickDateBtn:(WeekFromMonthFooterView *)footerView;

/** 点击确定按钮 */
- (void)WeekFromMonthFooterViewDidClickSureBtn:(WeekFromMonthFooterView *)footerView;

@end

@interface WeekFromMonthFooterView : UIView

+ (instancetype)footerView;

/**
 *  开始日期
 */
@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, weak) id<WeekFromMonthFooterViewDelegate>  delegate;

/** 日期选择器 */
@property (nonatomic, strong) DatePickerView  *datePickerView;
@property (nonatomic, strong)  UIView *cover;

@end

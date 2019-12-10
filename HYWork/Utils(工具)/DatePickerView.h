//
//  DatePickerView.h
//  HYWork
//
//  Created by information on 16/3/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerView;

typedef enum {
    DatePickerViewButtonTypeCancle,
    DatePickerViewButtonTypeSure
} DatePickerViewButtonType;

@protocol datePickerDelegate <NSObject>

/**
 点击 取消/确认 按钮回调

 @param datePickerView 日期控件
 @param buttonType 按钮类型
 */
- (void)didFinishDatePicker:(DatePickerView *)datePickerView buttonType:(DatePickerViewButtonType)buttonType;

@end

@interface DatePickerView : UIView

@property (nonatomic, strong)  UIDatePicker *datePicker;

@property (nonatomic, strong)  UIButton *sureButton;

@property (nonatomic, strong)  UIButton *cancelButton;

@property (nonatomic, copy) NSString *selectedDate;

@property (nonatomic, weak) id<datePickerDelegate> delegate;

@end

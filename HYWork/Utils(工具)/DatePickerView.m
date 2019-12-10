//
//  DatePickerView.m
//  HYWork
//
//  Created by information on 16/3/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat  width = self.frame.size.width;
        self.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        view.backgroundColor = [UIColor grayColor];
        [self addSubview:view];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, width, 196)];
        datePicker.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker = datePicker;
        NSString *minDateString = @"1990-01-01 0:0:0";
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
        NSDate *minDate = [dateFormater dateFromString:minDateString];
        
        NSString *maxDateString = @"2100-01-01 0:0:0";
        NSDateFormatter *maxFormater = [[NSDateFormatter alloc] init];
        [maxFormater setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
        NSDate *maxDate = [dateFormater dateFromString:maxDateString];
        
        datePicker.minimumDate = minDate;
        datePicker.maximumDate = maxDate;
        
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:datePicker];
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(width - 70, 10, 60, 20)];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1] forState:UIControlStateNormal];
        sureButton.tag = 1;
        sureButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [sureButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        _sureButton = sureButton;
        [self addSubview:sureButton];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1] forState:UIControlStateNormal];
        cancelButton.tag = 0;
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [cancelButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        _cancelButton = cancelButton;
        [self addSubview:cancelButton];
    }
    return self;
}

#pragma mark - 日期变化事件
- (void)datePickerValueChanged:(UIDatePicker *)datePicker {
    NSDate *selected = [datePicker date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    self.selectedDate = [dateFormater stringFromDate:selected];
}

#pragma mark - 取消/确认 选中日期
- (void)itemClick:(UIButton *)button {
    NSDate *selected = [self.datePicker date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    self.selectedDate = [dateFormater stringFromDate:selected];
    
    if ([self.delegate respondsToSelector:@selector(didFinishDatePicker:buttonType:)]) {
        [self.delegate didFinishDatePicker:self buttonType:(int)button.tag];
    }
}

@end

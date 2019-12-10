//
//  TimePickerView.h
//  HYWork
//
//  Created by information on 2017/6/5.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TimePickerViewButtonTypeCancle,
    TimePickerViewButtonTypeSure
}TimePickerViewButtonType;

@protocol timePickerDelegate <NSObject>

/**
 点击 取消/确定 按钮

 @param timeStr 选中的日期
 @param buttonType 按钮类别
 */
- (void)didFinishTimePicker:(NSString *)timeStr buttonType:(TimePickerViewButtonType)buttonType;

@end


@interface TimePickerView : UIView

@property (nonatomic, strong)  UIDatePicker *datePicker;

@property (nonatomic, strong)  UIButton *sureButton;

@property (nonatomic, strong)  UIButton *cancelButton;

@property (nonatomic, copy) NSString *selectedTime;

@property (nonatomic, weak) id<timePickerDelegate> delegate;

@end

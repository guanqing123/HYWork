//
//  SelectPickerView.h
//  HYWork
//
//  Created by information on 16/6/1.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectPickerView;

typedef enum {
    SelectPickerViewButtonTypeCancle,
    SelectPickerViewButtonTypeSure
}SelectPickerViewButtonType;

@protocol SelectPickerViewDelegate <NSObject>

/**
 点击 取消/确认 按钮回调

 @param selectPickerView 选择视图
 @param buttonType 按钮类型
 */
- (void)didFinishSelectPicker:(SelectPickerView *)selectPickerView buttonType:(SelectPickerViewButtonType)buttonType;

@end

@interface SelectPickerView : UIView

@property (nonatomic, strong)  NSMutableArray *dataArry;

@property (nonatomic, weak) UIPickerView  *pickerView;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) id<SelectPickerViewDelegate>  delegate;

@end

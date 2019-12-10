//
//  MultiSelectPickerView.h
//  HYWork
//
//  Created by information on 2018/11/19.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWork.h"
#import "RjhPlan.h"

@class MultiSelectPickerView;

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    MultiSelectPickerViewButtonTypeCancle,
    MultiSelectPickerViewButtonTypeSure
}MultiSelectPickerViewButtonType;

@protocol MultiSelectPickerViewDelegate <NSObject>
@optional

/**
 点击 取消/确认 按钮回调

 @param selectPickerView 选择视图
 @param buttonType 按钮类型
 */
- (void)didFinishMultiSelectPicker:(MultiSelectPickerView *)selectPickerView buttonType:(MultiSelectPickerViewButtonType)buttonType;

@end

@interface MultiSelectPickerView : UIView

@property (nonatomic, strong)  NSArray *workArray;

@property (nonatomic, strong) NSMutableArray *chooseArray;

@property (nonatomic, weak) id<MultiSelectPickerViewDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END

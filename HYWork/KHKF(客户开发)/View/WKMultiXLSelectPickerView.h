//
//  WKMultiXLSelectPickerView.h
//  HYWork
//
//  Created by information on 2018/11/21.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    WKMultiXLSelectPickerViewButtonTypeCancle,
    WKMultiXLSelectPickerViewButtonTypeSure
}WKMultiXLSelectPickerViewButtonType;

@class WKMultiXLSelectPickerView;
NS_ASSUME_NONNULL_BEGIN

@protocol WKMultiXLSelectPickerViewDelegate <NSObject>
@optional

/**
 点击 取消/确认 按钮

 @param selectPickerView 选择节目
 @param buttonType 按钮类型
 */
- (void)multiXlSelectPickerView:(WKMultiXLSelectPickerView *)selectPickerView buttonType:(WKMultiXLSelectPickerViewButtonType)buttonType;

@end

@interface WKMultiXLSelectPickerView : UIView

@property (nonatomic, copy) NSString *khdm;

@property (nonatomic, weak) id<WKMultiXLSelectPickerViewDelegate> delegate;

@property (nonatomic, strong)  NSMutableArray *chooseArray;

@end

NS_ASSUME_NONNULL_END

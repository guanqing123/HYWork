//
//  WeekFooterView.h
//  HYWork
//
//  Created by information on 16/5/25.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeekFooterView;

typedef enum {
    WeekFooterViewButtonTypeDelete,
    WeekFooterViewButtonTypePause,
    WeekFooterViewButtonTypeFinish,
    WeekFooterViewButtonTypeCommit
} WeekFooterViewButtonType;

typedef enum {
    WeekPlanStateTypeDefault,
    WeekPlanStateTypeCommit,
    WeekPlanStateTypeCancel
} WeekPlanStateType;

@protocol weekFooterViewDelegate <NSObject>
@optional

/** 点击 底部 添加按钮 */
- (void)weekFooterViewDidClickAddBtn:(WeekFooterView *)footerView;

/**
 *  点击底部 view 上的 button
 *
 *  @param footerView 底部 view
 *  @param buttonType view 上的button
 */
- (void)weekFooterView:(WeekFooterView *)footerView didClickButton:(WeekFooterViewButtonType)buttonType;

@end

@interface WeekFooterView : UIView

@property (nonatomic, assign, getter=isEdit) BOOL edit;

@property (nonatomic, assign, getter=isCommitAndDel) BOOL del;

@property (nonatomic, assign, getter=isPause) BOOL pause;

@property (nonatomic, assign, getter=isFinish) BOOL finish;

@property (nonatomic, assign, getter=isStateType) WeekPlanStateType stateType;

@property (nonatomic, weak) id<weekFooterViewDelegate>  delegate;

+ (instancetype)footerView:(CGRect)frame ly:(NSString *)ly;

- (void)fillDel:(BOOL)del pause:(BOOL)pause finish:(BOOL)finish sateType:(WeekPlanStateType)stateType;

@end

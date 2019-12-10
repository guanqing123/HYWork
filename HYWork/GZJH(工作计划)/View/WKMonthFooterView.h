//
//  WKMonthFooterView.h
//  HYWork
//
//  Created by information on 2019/8/23.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKMonthFooterView;

typedef enum {
    WKMonthFooterViewButtonTypeAdd,
    WKMonthFooterViewButtonTypeBatchCommit,
    WKMonthFooterViewButtonTypeBatchBack,
    WKMonthFooterViewButtonTypeApprove,
    WKMonthFooterViewButtonTypeCancleApprove
} WKMonthFooterViewButtonType;

NS_ASSUME_NONNULL_BEGIN

@protocol WKMonthFooterViewDelegate <NSObject>

/**
 触发按钮事件

 @param footerView 当前view
 @param buttonType 按钮类型
 */
- (void)monthFooterView:(WKMonthFooterView *)footerView buttonType:(WKMonthFooterViewButtonType)buttonType;

@end

@interface WKMonthFooterView : UIView

+ (instancetype)footerView;

@property (nonatomic, assign) int ly;

@property (nonatomic, weak) id<WKMonthFooterViewDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END

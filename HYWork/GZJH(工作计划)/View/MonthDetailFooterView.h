//
//  MonthDetailFooterView.h
//  HYWork
//
//  Created by information on 16/6/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthPlan.h"
@class MonthDetailFooterView;

@protocol MonthDetailFooterViewDelegate <NSObject>
@optional

/** 点击 删除 按钮 */
- (void)monthDetailFooterViewDidClickDeleteBtn:(MonthDetailFooterView *)footerView;

/** 点击 保存 按钮 */
- (void)monthDetailFooterViewDidClickSaveBtn:(MonthDetailFooterView *)footerView;

/** 点击 取消 按钮 */
- (void)monthDetailFooterViewDidClickCancelBtn:(MonthDetailFooterView *)footerView;

@end


@interface MonthDetailFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong)  MonthPlan *monthPlan;

+ (instancetype)footerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<MonthDetailFooterViewDelegate> delegate;


@end
//
//  WeekDetailFooterView.h
//  HYWork
//
//  Created by information on 16/5/27.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekPlan.h"
@class WeekDetailFooterView;

@protocol WeekDetailFooterViewDelegate <NSObject>
@optional

/** 点击 删除 按钮 */
- (void)weekDetailFooterViewDidClickDeleteBtn:(WeekDetailFooterView *)footerView;

/** 点击 保存 按钮 */
- (void)weekDetailFooterViewDidClickSaveBtn:(WeekDetailFooterView *)footerView;

/** 点击 取消/提交 按钮 */
- (void)weekDetailFooterViewDidClickCancelBtn:(WeekDetailFooterView *)footerView;

@end


@interface WeekDetailFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong)  WeekPlan *weekPlan;

+ (instancetype)footerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<WeekDetailFooterViewDelegate> delegate;


@end

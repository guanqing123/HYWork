//
//  MonthPlanDetailCell.h
//  HYWork
//
//  Created by information on 16/6/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MonthPlan.h"
@class MonthPlanDetailCell;

@protocol MonthPlanDetailCellDelegate <NSObject>

/** 点击 主办人按钮 */
- (void)monthPlanDetailCellDidClickZbrBtn:(MonthPlanDetailCell *)monthPlanDetailCell;

/** 点击 协办人按钮 */
- (void)monthPlanDetailCellDidClickXbrBtn:(MonthPlanDetailCell *)monthPlanDetailCell;

@end

@interface MonthPlanDetailCell : UITableViewCell

@property (nonatomic, weak) id<MonthPlanDetailCellDelegate>  delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView rowIndex:(NSInteger)rowIndex;

@property (nonatomic, assign) NSInteger rowIndex;

+ (CGFloat)cellHeight:(NSInteger)rowIndex;

@property (nonatomic, strong)  MonthPlan *monthPlan;

@property (nonatomic, strong)  NSArray *sjld;

@end

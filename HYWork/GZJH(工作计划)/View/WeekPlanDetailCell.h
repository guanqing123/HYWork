//
//  WeekPlanDetailCell.h
//  HYWork
//
//  Created by information on 16/5/26.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekPlan.h"

@class WeekPlanDetailCell;

@protocol WeekPlanDetailCellDelegate <NSObject>

/** 点击工作类别按钮 */
- (void)weekPlanDetailCellDidClickGzlbBtn:(WeekPlanDetailCell *)weekPlanDetailCell;

/** 点击 主办人按钮 */
- (void)weekPlanDetailCellDidClickZbrBtn:(WeekPlanDetailCell *)weekPlanDetailCell;

/** 点击 协办人按钮 */
- (void)weekPlanDetailCellDidClickXbrBtn:(WeekPlanDetailCell *)weekPlanDetailCell;

@end

@interface WeekPlanDetailCell : UITableViewCell

@property (nonatomic, weak) id<WeekPlanDetailCellDelegate>  delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView rowIndex:(NSInteger)rowIndex;

@property (nonatomic, assign) NSInteger rowIndex;

@property (nonatomic, strong)  WeekPlan *weekPlan;

@property (nonatomic, strong)  NSArray *sjld;

+ (CGFloat)cellHeight:(NSInteger)rowIndex;

@end

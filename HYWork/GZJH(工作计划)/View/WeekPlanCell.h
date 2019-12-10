//
//  WeekPlanCell.h
//  HYWork
//
//  Created by information on 16/5/25.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekPlan.h"
@class WeekPlanCell;

@protocol weekPlanCellDelegate <NSObject>
@optional

- (void)weekPlanCellDidChoose:(WeekPlanCell *)weekPlanCell;

@end


@interface WeekPlanCell : UITableViewCell

@property (nonatomic, strong) WeekPlan *weekPlan;

@property (nonatomic, weak) id<weekPlanCellDelegate>  delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getCellHeight;

@end

//
//  WeekPlanListCell.h
//  HYWork
//
//  Created by information on 16/6/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeekPlan;

@interface WeekPlanListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)  WeekPlan *weekPlan;

+ (CGFloat)getCellHeight;

@end

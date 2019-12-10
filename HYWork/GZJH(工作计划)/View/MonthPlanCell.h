//
//  MonthPlanCell.h
//  HYWork
//
//  Created by information on 16/6/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthPlan.h"
#import "WKMonthPlan.h"
@class MonthPlanCell;

@protocol monthPlanCellDelegate <NSObject>
@optional

- (void)monthPlanCellDidChoose:(MonthPlanCell *)monthPlanCell;

@end


@interface MonthPlanCell : UITableViewCell

@property (nonatomic, strong) MonthPlan *monthPlan;

@property (nonatomic, strong)  WKMonthPlan *wkMonthPlan;

@property (nonatomic, weak) id<monthPlanCellDelegate>  delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getCellHeight;

@end

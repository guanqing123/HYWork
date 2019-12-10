//
//  WKMonthPlanCell.h
//  HYWork
//
//  Created by information on 2019/8/22.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKMonthPlan.h"
#import "MonthPlan.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKMonthPlanCell : UITableViewCell

@property (nonatomic, strong)  MonthPlan *monthPlan;

@property (nonatomic, strong)  WKMonthPlan *wkMonthPlan;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getCellHeight;

+ (CGFloat)getLdCellHeight;

@end

NS_ASSUME_NONNULL_END

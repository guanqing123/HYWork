//
//  MonthDetailHeaderView.h
//  HYWork
//
//  Created by information on 16/6/27.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthPlan.h"

@interface MonthDetailHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)  MonthPlan *monthPlan;

@end

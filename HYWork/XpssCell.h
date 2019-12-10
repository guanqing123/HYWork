//
//  XpssCell.h
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XpssModel.h"

@interface XpssCell : UITableViewCell

@property (nonatomic, strong)  XpssModel *xpssModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

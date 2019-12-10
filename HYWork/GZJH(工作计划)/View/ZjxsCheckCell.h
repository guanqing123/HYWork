//
//  ZjxsCheckCell.h
//  HYWork
//
//  Created by information on 16/6/12.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJXS.h"

@interface ZjxsCheckCell : UITableViewCell

@property (nonatomic, strong)  ZJXS *zjxs;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

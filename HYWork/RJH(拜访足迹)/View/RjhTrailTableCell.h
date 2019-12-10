//
//  RjhTrailTableCell.h
//  HYWork
//
//  Created by information on 2017/7/26.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhTrail.h"

@interface RjhTrailTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)  RjhTrail *trail;

@end

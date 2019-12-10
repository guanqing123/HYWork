//
//  SettingCell.h
//  HYWork
//
//  Created by information on 16/4/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingItem;

@interface SettingCell : UITableViewCell

@property (nonatomic, strong)  SettingItem  *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

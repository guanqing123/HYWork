//
//  SettingCell.h
//  HYWork
//
//  Created by information on 16/4/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingItem,SettingCell;

@protocol SettingCellDelegate <NSObject>
@optional

/// 重启app
/// @param settingCell 当前cell
- (void)tableViewCellRestartApp:(SettingCell *)settingCell;

@end

@interface SettingCell : UITableViewCell

@property (nonatomic, strong)  SettingItem  *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<SettingCellDelegate> delegate;

@end

//
//  BXHeaderView.h
//  HYWork
//
//  Created by information on 16/5/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BXGroup,BXHeaderView;

@protocol BXHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedNameView:(BXHeaderView *)headerView;
@end

@interface BXHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BXGroup *group;

@property (nonatomic, weak) id<BXHeaderViewDelegate>  delegate;

@end

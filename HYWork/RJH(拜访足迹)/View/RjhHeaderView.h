//
//  RjhHeaderView.h
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RjhHeaderView;

@protocol RjhHeaderViewDelegate <NSObject>
@optional
/** 日期变更刷新数据 */
- (void)headerViewChangeRefreshTableView:(RjhHeaderView *)headerView;
/** 点击轨迹图 */
- (void)headerViewDidClickTrailBtn:(RjhHeaderView *)headerView;
@end

@interface RjhHeaderView : UIView

@property (nonatomic, copy) NSString *currentDate;

@property (nonatomic, weak) id<RjhHeaderViewDelegate> delegate;

+ (instancetype)headerView;

- (void)setupDateCondition;

@end

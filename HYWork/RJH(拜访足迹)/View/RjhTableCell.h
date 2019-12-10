//
//  RjhTableCell.h
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanToolBarView.h"
#import "RjhRemark.h"
@class RjhPlanFrame;
@class RjhTableCell;

@protocol RjhTableCellDelegate <NSObject>
@optional
/** 点击底部工具条按钮 */
- (void)tableCell:(RjhTableCell *)tableCell buttonType:(ToolBarButtonType)buttonType;
/** 点击头部颜色条 考勤按钮 */
- (void)tableCellTopColorViewDidClickAttendanceBtn:(RjhTableCell *)tableCell;
/** 回复某人 */
- (void)tableCell:(RjhTableCell *)tableCell replyRemark:(RjhRemark *)remark;
/** 删除评论 */
- (void)tableCell:(RjhTableCell *)tableCell deleteRemark:(RjhRemark *)remark;
@end

@interface RjhTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)  RjhPlanFrame *planFrame;

@property (nonatomic, weak) id<RjhTableCellDelegate> delegate;
@end

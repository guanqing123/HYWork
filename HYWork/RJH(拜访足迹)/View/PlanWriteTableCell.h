//
//  PlanWriteTableCell.h
//  HYWork
//
//  Created by information on 2017/5/22.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhPlan.h"
@class PlanWriteTableCell;

@protocol PlanWriteTableCellDelegate <NSObject>
@optional

/**
 点击工作项,变更客户工作类别

 @param planWriteCell 当前cell
 */
- (void)didFinishPlanType:(PlanWriteTableCell *)planWriteCell;


/**
 点击客户建档,刷新客户信息

 @param planWriteCell 当前cell
 */
- (void)didFinishBpcType:(PlanWriteTableCell *)planWriteCell;


/**
 点击客户工作类别,变更客户具体工作项

 @param planWriteCell 当前cell
 */
- (void)didFinishWorkType:(PlanWriteTableCell *)planWriteCell;


/**
 点击客户具体工作项,变更“备注”是否显示

 @param planWriteCell 当前cell
 */
- (void)didFinishWork:(PlanWriteTableCell *)planWriteCell;

/** cell点击承办人按钮 */
- (void)planWriteTableCellDidClickOperatorSearch:(PlanWriteTableCell *)planWriteCell;
/** cell点击客户搜索框 */
- (void)planWriteTableCellDidClickBpcSearch:(PlanWriteTableCell *)planWriteCell bpcType:(BpcType)bpcType;
/** cell点击客户电话 */
- (void)planWriteTableCellDidClickTelSearch:(PlanWriteTableCell *)planWriteCell;
/** cell点击足迹按钮 */
- (void)planWriteTableCellDidClickTrack:(PlanWriteTableCell *)planWriteCell;
@end

@interface PlanWriteTableCell : UITableViewCell
/** 传NSIndexPath进来 */
@property (nonatomic, assign) NSIndexPath *indexPath;
/** 传计划模型 */
@property (nonatomic, strong)  RjhPlan *plan;

+ (instancetype)cellWithTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id<PlanWriteTableCellDelegate> delegate;

@property (nonatomic, strong)  NSArray *zjxs;

@property (nonatomic, strong)  NSArray *selectData;

/**
 工作项选项
 */
@property (nonatomic, strong)  NSMutableArray *workTypeResultArray;

/**
 客户工作类别
 */
@property (nonatomic, strong)  NSArray *workTypeArray;

/**
 客户具体工作项
 */
@property (nonatomic, strong)  NSArray *workArray;

/**
 项目列表
 */
@property (nonatomic, strong)  NSArray *projectList;

@end

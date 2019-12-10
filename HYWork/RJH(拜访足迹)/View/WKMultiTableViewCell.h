//
//  WKMultiTableViewCell.h
//  HYWork
//
//  Created by information on 2018/11/19.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWork.h"
#import "RjhPlan.h"
@class WKMultiTableViewCell;

@protocol WKMultiTableViewCellDelegate <NSObject>
@optional

/**
 刷新表格

 @param tableViewCell 当前cell
 */
- (void)multiTableViewCell:(WKMultiTableViewCell *)tableViewCell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WKMultiTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)  WKWork *work;

@property (nonatomic, strong)  NSMutableArray *chooseArray;

@property (nonatomic, weak) id<WKMultiTableViewCellDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END

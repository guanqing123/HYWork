//
//  WKMultiXLTableViewCell.h
//  HYWork
//
//  Created by information on 2018/11/21.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKTjz5.h"
@class WKMultiXLTableViewCell;

@protocol WKMultiXLTableViewCellDelegate <NSObject>
@optional

/**
 刷新 tableView

 @param tableViewCell 当前Cell
 */
- (void)multiXlTableViewCell:(WKMultiXLTableViewCell *_Nullable)tableViewCell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WKMultiXLTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)  WKTjz5 *tjz5;

@property (nonatomic, strong)  NSMutableArray *chooseArray;

@property (nonatomic, weak) id<WKMultiXLTableViewCellDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END

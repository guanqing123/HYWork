//
//  BrowseMultiCell.h
//  HYWork
//
//  Created by information on 16/5/31.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrowseMultiCell;

@protocol BrowseMultiCellDelegate <NSObject>

- (void)browseMultiCellDidClickCell:(BrowseMultiCell *)browseMultiCell;

@end

@interface BrowseMultiCell : UITableViewCell

/**
 *  员工编码
 */
@property (nonatomic, copy) NSString *ygbm;

/**
 *  字典
 */
@property (nonatomic, strong)  NSDictionary *dict;

/**
 *  是否选中
 */
@property (nonatomic, assign, getter=isChoosed) BOOL choosed;


@property (nonatomic, weak) id<BrowseMultiCellDelegate>  delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getCellHeight;

@end

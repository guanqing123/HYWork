//
//  WKCommonTableViewCell.h
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHomeWork.h"
@class WKCommonTableViewCell;

@protocol WKCommonTableViewCellDelegate <NSObject>
@optional

/// 点击常用item
/// @param tableViewCell tableViewCell
/// @param homeWork item
- (void)commonTableViewCell:(WKCommonTableViewCell *_Nullable)tableViewCell didClickCollectionViewItem:(WKHomeWork *_Nonnull)homeWork;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WKCommonTableViewCell : UITableViewCell

@property (nonatomic, strong)  NSMutableArray<WKHomeWork *> *commons;

@property (nonatomic, weak) id<WKCommonTableViewCellDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END

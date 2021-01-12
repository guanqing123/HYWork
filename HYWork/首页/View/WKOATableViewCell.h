//
//  WKOATableViewCell.h
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHomeWork.h"
@class WKOATableViewCell;

@protocol WKOATableViewCellDelegate <NSObject>
@optional

/// 点击OA办公item
/// @param tableViewCell tableViewCell
/// @param homeWork item
- (void)oaTableViewCell:(WKOATableViewCell *_Nullable)tableViewCell didClickCollectionViewItem:(WKHomeWork *_Nonnull)homeWork;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WKOATableViewCell : UITableViewCell

@property (nonatomic, strong)  NSMutableArray<WKHomeWork *> *oaWorks;

@property (nonatomic, weak) id<WKOATableViewCellDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END

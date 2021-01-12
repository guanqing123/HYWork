//
//  WKDefineTableViewCell.h
//  HYWork
//
//  Created by information on 2021/1/13.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHomeWork.h"
@class WKDefineTableViewCell;

@protocol WKDefineTableViewCellDelegate <NSObject>
@optional

/// 点击自定义item
/// @param tableViewCell tableViewCell
/// @param homeWork item
- (void)defineTableViewCell:(WKDefineTableViewCell *_Nullable)tableViewCell didClickCollectionViewItem:(WKHomeWork *_Nonnull)homeWork;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WKDefineTableViewCell : UITableViewCell

@property (nonatomic, strong)  NSMutableArray<WKHomeWork *> *defines;

@property (nonatomic, weak) id<WKDefineTableViewCellDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END

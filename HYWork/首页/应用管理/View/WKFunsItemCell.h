//
//  WKFunsItemCell.h
//  HYWork
//
//  Created by information on 2021/1/13.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHomeWork.h"
@class WKFunsItemCell;

@protocol WKFunsItemCellDelegate <NSObject>
@optional

/// 右上角点击
/// @param selectedItemCell 当前cell
- (void)rightUpperButtonDidTappedWithItemCell:(WKFunsItemCell *_Nullable)selectedItemCell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WKFunsItemCell : UICollectionViewCell

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) WKHomeWork *homeWork;

@property (nonatomic, weak) id <WKFunsItemCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL isEditing;

@end

NS_ASSUME_NONNULL_END

//
//  WKNoticeSectionHeaderView.h
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKNoticeSectionHeaderView;

NS_ASSUME_NONNULL_BEGIN

@protocol WKNoticeSectionHeaderViewDelegate <NSObject>
@optional

/// 点击headerView
/// @param headerView 当前view
- (void)headerViewDidClick:(WKNoticeSectionHeaderView *)headerView;

@end

@interface WKNoticeSectionHeaderView : UIView

@property (nonatomic, weak) id<WKNoticeSectionHeaderViewDelegate>  delegate;

+ (instancetype)sectionHeaderView;

@end

NS_ASSUME_NONNULL_END

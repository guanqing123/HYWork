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
/// @param noticeId 通知ID
- (void)headerViewDidClick:(WKNoticeSectionHeaderView *)headerView currentNoticeId:(NSString *)noticeId;

@end

@interface WKNoticeSectionHeaderView : UIView

@property (nonatomic, weak) id<WKNoticeSectionHeaderViewDelegate>  delegate;

- (void)start;

- (void)stop;

+ (instancetype)sectionHeaderView;

@end

NS_ASSUME_NONNULL_END

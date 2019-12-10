//
//  WKQdkhHeaderView.h
//  HYWork
//
//  Created by information on 2018/11/20.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKQdkhHeaderView;
@class WKQdkh;
NS_ASSUME_NONNULL_BEGIN

@protocol WKQdkhHeaderViewDelegate <NSObject>
@optional

/**
 客户代码点击

 @param headerView 当前view
 */
- (void)qdkhHeaderViewkhdmBtnDidClick:(WKQdkhHeaderView *)headerView;


/**
 访问通讯录

 @param headerView 当前view
 */
- (void)qdkhHeaderViewVisitedAddressList:(WKQdkhHeaderView *)headerView;

@end

@interface WKQdkhHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<WKQdkhHeaderViewDelegate> delegate;

@property (nonatomic, strong)  WKQdkh *qdkh;

@end

NS_ASSUME_NONNULL_END

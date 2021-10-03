//
//  WKXmSearchViewController.h
//  HYWork
//
//  Created by information on 2021/10/3.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
// model
#import "WKProjectResult.h"

@class WKXmSearchViewController;

NS_ASSUME_NONNULL_BEGIN
@protocol WKXmSearchViewControllerDelegate <NSObject>
@optional

/// 检索项目
/// @param xmSearchVc 项目控制器
- (void)xmSearchViewDidSelectXm:(WKXmSearchViewController *)xmSearchVc;

@end

@interface WKXmSearchViewController : UIViewController

@property (nonatomic, strong) NSArray *xmArray;

@property (nonatomic, weak) id<WKXmSearchViewControllerDelegate> delegate;

// 选中的项目
@property (nonatomic, strong)  WKProjectResult *selectPR;

// 标记位,需要复原
@property (nonatomic, assign) BOOL create;
// 标记位,不要复原
@property (nonatomic, assign) BOOL hasCreate;

@end

NS_ASSUME_NONNULL_END

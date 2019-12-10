//
//  RjhBpcSearchViewController.h
//  HYWork
//
//  Created by information on 2017/6/6.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BpcHistoryCheckView.h"
@class RjhBpcSearchViewController;

@protocol RjhBpcSearchViewControllerDelegate <NSObject>
@optional

/**
 选择客户之后的回调

 @param bpcSearchVc 检索客户窗体
 */
- (void)rjhBpcSearchViewControllerDidSelectBpc:(RjhBpcSearchViewController *)bpcSearchVc;
@end

@interface RjhBpcSearchViewController : UIViewController

@property (nonatomic, strong)  RjhBPC *bpc;

@property (nonatomic, strong)  BpcHistoryCheckView *historyView;

@property (nonatomic, weak) id<RjhBpcSearchViewControllerDelegate> delegate;

@end

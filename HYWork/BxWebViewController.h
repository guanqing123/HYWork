//
//  BxWebViewController.h
//  HYWork
//
//  Created by information on 16/5/11.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BXItem.h"
@class BxWebViewController;

@protocol BxWebViewControllerDelegate <NSObject>
@optional
- (void)bxWebViewControllerGoBackAndRefresh:(BxWebViewController *)bxWebVc;
@end

@interface BxWebViewController : UIViewController

@property (nonatomic, weak) id<BxWebViewControllerDelegate>  delegate;

- (instancetype)initWithBXItem:(BXItem *)item;

@end

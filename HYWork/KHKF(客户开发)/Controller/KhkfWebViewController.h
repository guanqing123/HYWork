//
//  KhkfWebViewController.h
//  HYWork
//
//  Created by information on 2017/7/24.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KhkfWebViewController;

@protocol KhkfWebViewControllerDelegate <NSObject>
@optional
- (void)khkfWebViewControllerDidBackItem:(KhkfWebViewController *)webVc;
@end

@interface KhkfWebViewController : UIViewController

- (instancetype)initWithXh:(NSString *)xh ywy:(NSString *)ywy;

@property (nonatomic, weak) id<KhkfWebViewControllerDelegate>  delegate;

@end

//
//  KhSearchViewController.h
//  HYWork
//
//  Created by information on 2017/7/25.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QzBpc.h"
@class KhSearchViewController;

@protocol KhSearchViewControllerDelegate <NSObject>
@optional
- (void)khSearchViewControllerChooseKh:(KhSearchViewController *)khSearchVc qzkh:(QzBpc *)qzbpc;
@end

@interface KhSearchViewController : UIViewController

@property (nonatomic, weak) id<KhSearchViewControllerDelegate>  delegate;

@end

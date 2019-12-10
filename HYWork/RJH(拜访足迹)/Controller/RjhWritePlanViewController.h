//
//  RjhWritePlanViewController.h
//  HYWork
//
//  Created by information on 2017/5/22.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhPlan.h"
@class RjhWritePlanViewController;

@protocol RjhWritePlanViewControllerDelegate <NSObject>
@optional
- (void)rjhWritePlanViewControllerSavePlan:(RjhWritePlanViewController *)writePlanVc;
@end

@interface RjhWritePlanViewController : UITableViewController

@property (nonatomic, strong)  RjhPlan *plan;

@property (nonatomic, weak) id<RjhWritePlanViewControllerDelegate> delegate;

@property (nonatomic, strong)  NSArray *zjxs;
@end

//
//  RjhSignInTableViewController.h
//  HYWork
//
//  Created by information on 2017/5/26.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "RjhPlan.h"
#import "RJHConstans.h"

@interface RjhSignInTableViewController : UITableViewController

@property (nonatomic, assign) int logid;

@property (nonatomic, strong)  RjhPlan *plan;

- (instancetype)initWithPlan:(RjhPlan *)plan;

@end

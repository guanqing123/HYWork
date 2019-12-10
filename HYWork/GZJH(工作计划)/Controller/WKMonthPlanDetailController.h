//
//  WKMonthPlanDetailController.h
//  HYWork
//
//  Created by information on 2019/8/27.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKMonthPlan.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKMonthPlanDetailController : UIViewController

- (instancetype)initWithXh:(NSString *)xh;

- (instancetype)initWithXh:(NSString *)xh sonPlan:(NSString *)sonPaln;

@end

NS_ASSUME_NONNULL_END

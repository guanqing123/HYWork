//
//  WKMonthViewController.h
//  HYWork
//
//  Created by information on 2019/8/21.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKMonthViewController : UIViewController

/**
 *  直接下属
 */
@property (nonatomic, strong)  NSArray *zjxs;

/**
 *  上级领导
 */
@property (nonatomic, strong)  NSArray *sjld;

@end

NS_ASSUME_NONNULL_END

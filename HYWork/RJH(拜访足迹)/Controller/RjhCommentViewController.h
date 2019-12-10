//
//  RjhCommentViewController.h
//  HYWork
//
//  Created by information on 2017/6/12.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhRemark.h"
@class RjhCommentViewController;

@protocol RjhCommentViewControllerDelegate <NSObject>
@optional
- (void)rjhCommentViewControllerDidComment:(RjhCommentViewController *)commentVc;
@end

@interface RjhCommentViewController : UIViewController
- initWithLogid:(NSString *)logid rjhRemark:(RjhRemark *)remark;

@property (nonatomic, weak) id<RjhCommentViewControllerDelegate> delegate;
@end

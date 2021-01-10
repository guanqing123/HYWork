//
//  WKQdkhViewController.h
//  HYWork
//
//  Created by information on 2018/11/20.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKQdkhViewController;

@protocol WKQdkhViewControllerDelegate <NSObject>
@optional

/**
 刷新控制器

 @param qdkhVc 渠道客户新增控制器
 */
- (void)qdkhViewControllerFinishSave:(WKQdkhViewController *_Nullable)qdkhVc;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WKQdkhViewController : UIViewController

/**
 备案序号
 */
@property (nonatomic, copy) NSString *bzxh;

@property (nonatomic, weak) id<WKQdkhViewControllerDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END

//
//  WKBusinessViewController.h
//  HYWork
//
//  Created by information on 2021/5/7.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKBusinessViewController : UIViewController

// 目标路径
@property (nonatomic, copy) NSString *desUrl;

- (instancetype)initWithDesUrl:(NSString *)desUrl;

- (void)reload;

@end

NS_ASSUME_NONNULL_END

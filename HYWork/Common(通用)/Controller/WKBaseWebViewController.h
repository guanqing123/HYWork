//
//  WKBaseWebViewController.h
//  HYWork
//
//  Created by information on 2020/12/3.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WKBaseWebViewController : UIViewController

// 目标路径
@property (nonatomic, copy) NSString *desUrl;

- (instancetype)initWithDesUrl:(NSString *)desUrl;

@end

NS_ASSUME_NONNULL_END

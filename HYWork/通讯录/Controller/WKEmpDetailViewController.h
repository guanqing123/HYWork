//
//  WKEmpDetailViewController.h
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKEmpDetailViewController : UIViewController

/// 员工详情
/// @param gh 工号
- (instancetype)initWithGh:(NSString *)gh;

@end

NS_ASSUME_NONNULL_END

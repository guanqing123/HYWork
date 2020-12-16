//
//  WKAllEmpViewController.h
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKAllEmpViewController : UIViewController

@property (nonatomic, strong)  NSDictionary *commonDict;

- (void)requestAllEmpsThroughSQLServerWithBlock:(void(^)())block;

@end

NS_ASSUME_NONNULL_END

//
//  WKBrowseAllViewController.h
//  HYWork
//
//  Created by information on 2018/5/19.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKBrowseAllViewController : UIViewController

- (void)refreshAllEmpsThroughSQLServerWithBlock:(void(^)())block;

@end

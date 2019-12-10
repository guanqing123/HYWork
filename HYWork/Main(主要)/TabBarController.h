//
//  UITabBarController.h
//  HYWork
//
//  Created by information on 16/2/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController,TxlViewController,GNViewController,MyViewController;

@interface TabBarController : UITabBarController
@property (strong, nonatomic)  ViewController *viewController;
@property (strong, nonatomic)  TxlViewController *txlController;
@property (strong, nonatomic)  GNViewController *gnViewController;
@property (strong, nonatomic)  MyViewController *myViewController;
@end

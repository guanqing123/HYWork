//
//  AppDelegate.h
//  HYWork
//
//  Created by information on 16/2/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarController.h"
#import "LoadViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//@interface AppDelegate : IFAppDelegate

@property (strong, nonatomic) UIWindow *window;
/**
 *  weak(assign) : 代理\UI控件
 *  strong(retain) : 其他对象(除代理\UI控件\字符串以外的对象)
 *  copy : 字符串
 *  assign : 非对象类型(基本数据类型int\float\BOOL\枚举\结构体)
 */
@property (strong, nonatomic)  TabBarController *tabBarViewController;

@end


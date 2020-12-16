//
//  UITabBarController.h
//  HYWork
//
//  Created by information on 16/2/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController,WKLearnViewController,WKHyShopViewController,GNViewController,MyViewController;

typedef enum {
  TabBarItemTypeIndex = 0,  //首页
  TabBarItemTypeLearning = 1, //学习
  TabBarItemTypeHyshop = 2, //鸿雁商城
  TabBarItemTypeFunction = 3, //功能
  TabBarItemTypeMe = 4 //我的
} TabBarItemType;

@interface TabBarController : UITabBarController
@property (strong, nonatomic)  ViewController *viewController;
@property (nonatomic, strong)  WKLearnViewController *learnVc;
@property (strong, nonatomic)  WKHyShopViewController *hyshopVc;
@property (strong, nonatomic)  GNViewController *gnViewController;
@property (strong, nonatomic)  MyViewController *myViewController;
@end

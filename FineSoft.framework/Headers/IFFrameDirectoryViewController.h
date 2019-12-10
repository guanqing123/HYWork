//
//  IFFrameDirectoryViewController.h
//  IFWidget
//
//  Created by WeiYanglu on 14-9-23.
//  Copyright (c) 2014年 FineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  一个对外开放创建目录树的工厂类
 */
@interface IFFrameDirectoryViewController : UIViewController

/**
 * 根据目录信息数组创建目录树
 * @param reportsArray 目录数组
 *
 * @return 目录树ViewController
 */
+ (id) directoryViewControllerWithReportsArray: (NSMutableArray *) reportsArray;

/**
 *  跳转到首页
 *  @param animate 跳转过程是否需要动画
 */
- (void) toDashBoard: (BOOL) animate;

- (void) puthToDirectory: (NSString*) entryid;

/**
 * -initWithReportsArray is deprecated. Use + directoryViewControllerWithReportsArray instead
 */
- (UIViewController *) initWithReportsArray: (NSMutableArray *) reportsArray;

-(void) releaseViewController;

-(void) backToParentView;

-(void) pushToEntry:(NSMutableDictionary *) lastInfo;

@end

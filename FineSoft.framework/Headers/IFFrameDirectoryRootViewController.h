//
//  IFFrameReportsViewController.h
//  IFWidget
//
//  Created by WeiYanglu on 14-7-15.
//  Copyright (c) 2014年 FineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//目录树的第一层，一共2层。第一层只有文件夹
@interface IFFrameDirectoryRootViewController : UIViewController<UIGestureRecognizerDelegate, UISearchBarDelegate>

- (instancetype) initWithReports:(NSMutableArray *) reports;

- (void) toDashBoard:(BOOL) animate;

- (void) pushToRoot:(NSString*)reportName;

- (void)cprUpdate:(NSNotification *)notification;

-(void) releaseViewController;

-(void) pushToEntry:(NSMutableDictionary *) lastInfo;

@end

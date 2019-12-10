//
//  LoadViewController.h
//  HYWork
//
//  Created by information on 16/3/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MJ.h"
#import "LoginManager.h"
#import "Emp.h"
@class LoadViewController;

@protocol  LoadViewControllerDelegate <NSObject>
@optional

- (void)loadViewControllerFinishLogin:(LoadViewController *)loadViewController;

@end

@interface LoadViewController : UIViewController

@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, weak) UITextField  *userTextField;
@property (nonatomic, weak) UILabel  *userLabel;

@property (nonatomic, weak) UITextField  *passwordTextField;
@property (nonatomic, weak) UILabel  *passwordLabel;

@property (nonatomic, weak) UIButton  *loadButton;

@property (nonatomic, assign, getter=isLoaded) BOOL loading;

@property (nonatomic, strong)  Emp *emp;

@property (nonatomic, weak) id<LoadViewControllerDelegate> delegate;

+ (instancetype)shareInstance;

@end

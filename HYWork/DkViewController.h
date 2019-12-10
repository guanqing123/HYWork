//
//  DkViewController.h
//  HYWork
//
//  Created by information on 16/3/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//  到款查询

#import <UIKit/UIKit.h>
#import "DkConditionView.h"

@interface DkViewController : UIViewController

@property (nonatomic,weak) UITableView  *tableView;

@property (strong, nonatomic)  DkConditionView *dkConditionView;

@property (nonatomic, assign, getter = isAppeared)  BOOL appeared;

@property (nonatomic,weak) UIScrollView  *scrollView;

@property (strong, nonatomic)  NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *hkzje;

@end

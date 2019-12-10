//
//  RjhOperatorSearchViewController.h
//  HYWork
//
//  Created by information on 2017/6/9.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RjhOperatorSearchViewController;

@protocol RjhOperatorSearchViewControllerDelegate <NSObject>
@optional
- (void)operatorSearchViewControllerDidBackLeftBarButtonItem:(RjhOperatorSearchViewController *)operatorSearchVc;
@end

@interface RjhOperatorSearchViewController : UIViewController

@property (nonatomic, copy) NSString *operatorid;
@property (nonatomic, strong) NSArray *operatorArray;

@property (nonatomic, copy) NSString *operatorname;
@property (nonatomic, strong)  NSArray *operatornameArray;

@property (nonatomic, strong)  NSArray *zjxsArray;
@property (nonatomic, strong)  NSMutableArray *dataArray;

@property (nonatomic, strong)  NSMutableDictionary *selectDict;

@property (nonatomic, weak) id<RjhOperatorSearchViewControllerDelegate>  delegate;

/** 初始化数据 */
- (void)setOperatorId:(NSString *)operatorid operatorName:(NSString *)operatorname zjxsArray:(NSArray *)zjxsArray;

@end

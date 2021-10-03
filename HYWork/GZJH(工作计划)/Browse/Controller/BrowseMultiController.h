//
//  BrowseMultiController.h
//  HYWork
//
//  Created by information on 16/5/31.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrowseMultiController;

@protocol BrowseMultiControllerDelegate <NSObject>

- (void)browseMultiControllerDidBackLeftBarButtonItem:(BrowseMultiController *)browseMultiController;

@end

@interface BrowseMultiController : UIViewController

@property (nonatomic, strong)  NSDictionary *citiesDic;
@property (nonatomic, strong)  NSDictionary *tempDict;

@property (nonatomic, copy)  NSString *xbrStr;
@property (nonatomic, strong)  NSArray *xbrArray;

@property (nonatomic, copy) NSString *xbrmcStr;
@property (nonatomic, strong)  NSArray *xbrmcArray;

@property (nonatomic, strong)  NSMutableArray *ygbmArray;
@property (nonatomic, strong)  NSMutableDictionary *dicts;

@property (nonatomic, weak) id<BrowseMultiControllerDelegate>  delegate;

- (void)refreshAllEmpsThroughSQLServerWithBlock:(void(^)(void))block;

- (void)fillXbrStr:(NSString *)xbrStr xbrmcStr:(NSString *)xbrmcStr;

@end

//
//  DtsController.h
//  HYWork
//
//  Created by information on 16/3/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestData.h"
#import "DtManager.h"
#import "DtDetailController.h"

@interface DtsController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic, strong)  UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;
@property (strong, nonatomic)  DtDetailController *dtDetailController;
@property (strong, nonatomic)  UISearchController *searchController;
@property (strong, nonatomic)  NSMutableArray *searchArray;
@property (strong, nonatomic)  NSMutableArray *resultArray;
@property (strong, nonatomic) NSMutableArray *beSearchArrar;
@property (assign, nonatomic) BOOL isSearching;

@end

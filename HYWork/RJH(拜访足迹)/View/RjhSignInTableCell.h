//
//  RjhSignInTableCell.h
//  HYWork
//
//  Created by information on 2017/5/26.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "RjhSignIn.h"
@class RjhSignInTableCell;

@protocol RjhSignInTableCellDelegate <NSObject>
@optional
/** 刷新地图位置 */
- (void)signInTableCellRefreshLocation:(RjhSignInTableCell *)signInCell;
/** 签到 */
- (void)signInTableCell:(RjhSignInTableCell *)signInCell;
@end

@interface RjhSignInTableCell : UITableViewCell

/** 传NSIndexPath进来 */
@property (nonatomic, assign) NSIndexPath *indexPath;

/** RjhSignIn 数据模型 */
@property (nonatomic, strong)  RjhSignIn *signIn;

/** delegate 对象*/
@property (nonatomic, weak) id<RjhSignInTableCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) MAMapView  *mapView;

@end

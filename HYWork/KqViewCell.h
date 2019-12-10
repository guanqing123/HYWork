//
//  KqViewCell.h
//  HYWork
//
//  Created by information on 16/3/31.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
@class KqViewCell;

@protocol kqViewCellDelegate <NSObject>
@optional

- (void)kqViewCellBtnClickToRefreshLocation:(KqViewCell *)kqViewCell;

@end

@interface KqViewCell : UITableViewCell

@property (nonatomic, copy) NSString *wz;

@property (nonatomic, assign, getter=isClick) BOOL click;

@property (nonatomic, copy) NSString *imgName;

@property (nonatomic, weak) id<kqViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setBtnImg:(NSString *)imgName andClick:(BOOL)click;

@property (nonatomic, weak) MAMapView  *mapView;

@end

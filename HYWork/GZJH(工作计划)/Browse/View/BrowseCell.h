//
//  BrowseCell.h
//  HYWork
//
//  Created by information on 16/5/31.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseCell : UITableViewCell
/**
 *  员工姓名
 */
@property (nonatomic, copy) NSString *ygxm;
/**
 *  职位说明
 */
@property (nonatomic, copy) NSString *zwsm;
/**
 *  手机号码
 */
@property (nonatomic, copy) NSString *mobile;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getCellHeight;
@end

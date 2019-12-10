//
//  WKBrowseTableViewCell.h
//  HYWork
//
//  Created by information on 2018/5/19.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKBrowseTableViewCell : UITableViewCell

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

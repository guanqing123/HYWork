//
//  WKAddressListTableViewCell.h
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKAddressListTableViewCell : UITableViewCell

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

/**
    创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
    cell高度
 */
+ (CGFloat)getCellHeight;

@end

NS_ASSUME_NONNULL_END

//
//  OperatorSearchTableCell.h
//  HYWork
//
//  Created by information on 2017/6/9.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJXS.h"
@class OperatorSearchTableCell;

@protocol OperatorSearchTableCellDelegate <NSObject>
@optional
- (void)operatorSearchTableCellDidClickMarkBtn:(OperatorSearchTableCell *)tableCell;
@end

@interface OperatorSearchTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)  ZJXS *zjxs;

@property (nonatomic, assign, getter=isChoosed) BOOL choosed;

@property (nonatomic, weak) id<OperatorSearchTableCellDelegate>  delegate;

@end

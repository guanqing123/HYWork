//
//  CygnTableCell.h
//  HYWork
//
//  Created by information on 16/2/26.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@class CygnTableCell;

@protocol CygnTableCellDelegate <NSObject>
@optional

- (void)cygnTableCell:(CygnTableCell *)cygnTableCell btnDidClickWithItem:(Item *)item;

@end

@interface CygnTableCell : UITableViewCell

@property (nonatomic,weak) id<CygnTableCellDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *dataArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

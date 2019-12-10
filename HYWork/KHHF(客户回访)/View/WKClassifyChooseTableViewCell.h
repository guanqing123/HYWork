//
//  WKClassifyChooseTableViewCell.h
//  HYWork
//
//  Created by information on 2018/6/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKClassifyChooseTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) NSString *title;

@end

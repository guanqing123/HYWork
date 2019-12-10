//
//  CjwtHeaderView.h
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
@class CjwtHeaderView;

@protocol CjwtHeaderViewDelegate <NSObject>
- (void)headerViewDidClickedNameView:(CjwtHeaderView *)headerView;
@end

@interface CjwtHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)  QuestionModel *model;

@property (nonatomic, weak) id<CjwtHeaderViewDelegate>  delegate;

@end

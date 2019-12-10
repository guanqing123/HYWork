//
//  BpcHistoryCheckView.h
//  HYWork
//
//  Created by information on 2017/6/6.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhBPC.h"
@class BpcHistoryCheckView;

@protocol BpcHistoryCheckViewDelegate <NSObject>
@optional
/** 点击客户查询按钮 */
- (void)historyCheckViewDidSearchBpcByCondition:(BpcHistoryCheckView *)historyCheckView;
/** 点击历史记录tableCell */
- (void)historyCheckViewDidSelectHistoryTableCell:(BpcHistoryCheckView *)historyCheckView;
@end

@interface BpcHistoryCheckView : UIView

@property (nonatomic, strong)  RjhBPC *conditionBpc;

@property (nonatomic, weak) id<BpcHistoryCheckViewDelegate> delegate;

@end

//
//  HistoryHeaderView.h
//  HYWork
//
//  Created by information on 2017/6/7.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhBPC.h"
typedef enum {
    HistoryHeaderViewButtonTypeReset,
    HistoryHeaderViewButtonTypeSearch
}HistoryHeaderViewButtonType;

@class HistoryHeaderView;

@protocol HistoryHeaderViewDelegate <NSObject>
@optional
- (void)headerView:(HistoryHeaderView *)headerView buttonType:(HistoryHeaderViewButtonType)buttonType;
@end

@interface HistoryHeaderView : UIView

+ (instancetype)headerView;

@property (nonatomic, weak) id<HistoryHeaderViewDelegate> delegate;

@property (nonatomic, strong)  RjhBPC *conditionBpc;

@end

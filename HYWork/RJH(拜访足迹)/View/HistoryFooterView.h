//
//  HistoryFooterView.h
//  HYWork
//
//  Created by information on 2017/6/6.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryFooterView;

@protocol HistoryFooterViewDelegate <NSObject>
@optional
- (void)footerViewDidReloadTableView:(HistoryFooterView *)footerView;
@end

@interface HistoryFooterView : UIView

+ (instancetype)footerView;

@property (nonatomic, weak) id<HistoryFooterViewDelegate>  delegate;

@end

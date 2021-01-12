//
//  WKNumberScrollView.h
//  HYSmartPlus
//
//  Created by information on 2018/3/14.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKNumberScrollView;

@protocol WKNumberScrollViewDelegate <NSObject>

/**
 点击 button 触发事件

 @param numberScrollView 当前view
 */
- (void)numberScrollViewDidButtonClick:(WKNumberScrollView *)numberScrollView;

@end

@interface WKNumberScrollView : UIView

@property (nonatomic, strong)  NSArray *scrollArray;

@property (nonatomic, weak) id<WKNumberScrollViewDelegate> delegate;

+ (instancetype)scrollView;

/**
 定时器的循环时间
 */
@property (nonatomic , assign) NSInteger interval;

/**
 创建定时器并run
 */
- (void)startTimer;

@end

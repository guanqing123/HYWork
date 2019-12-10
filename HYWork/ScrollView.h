//
//  ScrollView.h
//  HYWork
//
//  Created by information on 16/4/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdScrollView.h"
@class ScrollView;

@protocol ScrollViewDelegate <NSObject>

- (void)scrollViewImgClick:(NSInteger)index;

@end

@interface ScrollView : UIView

@property (nonatomic, strong)  NSMutableArray *imgArry;

@property (nonatomic, strong)  AdScrollView *scrollView;

@property (nonatomic, weak) id<ScrollViewDelegate>  delegate;

- (void)scrollViewCreated:(NSArray *)imgArry;



@end

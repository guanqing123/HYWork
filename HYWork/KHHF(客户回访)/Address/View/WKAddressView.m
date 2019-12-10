//
//  WKAddressView.m
//  HYWork
//
//  Created by information on 2018/5/17.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKAddressView.h"

static  CGFloat  const  WKBarItemMargin = 20;

@interface WKAddressView()
@property (nonatomic, strong)  NSMutableArray *btnArray;
@end

@implementation WKAddressView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (NSInteger i = 0; i <= self.btnArray.count - 1; i++) {
        UIView *subView = self.btnArray[i];
        if (i == 0) {
            subView.dc_x = WKBarItemMargin;
        }
        if (i > 0) {
            UIView *preView = self.btnArray[i - 1];
            subView.dc_x = preView.dc_right + WKBarItemMargin;
        }
    }
}

- (NSMutableArray *)btnArray {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [tempArray addObject:subView];
        }
    }
    _btnArray = tempArray;
    return _btnArray;
}

@end

//
//  CustomerLabel.m
//  HYWork
//
//  Created by information on 2017/5/21.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "CustomerLabel.h"

@implementation CustomerLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end

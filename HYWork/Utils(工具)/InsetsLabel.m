//
//  InsetsLabel.m
//  HYWork
//
//  Created by information on 16/3/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "InsetsLabel.h"

@implementation InsetsLabel

@synthesize insets=_insets;

- (instancetype)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if (self) {
        self.insets = insets;
    }
    return self;
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if (self) {
        self.insets = insets;
    }
    return self;
}

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}
@end

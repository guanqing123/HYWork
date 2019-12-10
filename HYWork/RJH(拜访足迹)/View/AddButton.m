//
//  CustomerButton.m
//  HYWork
//
//  Created by information on 2017/5/22.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "AddButton.h"

@implementation AddButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL flag = [super pointInside:point withEvent:event];
    if (flag) {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        if ([path containsPoint:point]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end

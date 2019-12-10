//
//  ReusableView.m
//  HYWork
//
//  Created by information on 16/3/21.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "ReusableView.h"

@implementation ReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *subView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
        [self addSubview:subView1];
        _subView1 = subView1;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        _label = label;
       
        UIView *subView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
        subView2.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [self addSubview:subView2];
    }
    return self;
}

- (void)initText:(NSString *)text r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b {
    _text = text;
    self.label.text = text;
    self.subView1.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end

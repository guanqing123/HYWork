//
//  BpcSearchHeaderView.m
//  HYWork
//
//  Created by information on 2017/6/7.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "BpcSearchHeaderView.h"

#define BpcSearchHeaderViewLabelFont [UIFont boldSystemFontOfSize:15.0f]
#define borderWidth 0.5

@interface BpcSearchHeaderView()
@property (nonatomic, weak) UILabel  *khdmLabel;
@property (nonatomic, weak) UILabel  *khmcLabel;
@end

@implementation BpcSearchHeaderView

+ (instancetype)headerView {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *khdmLabel = [[UILabel alloc] init];
        khdmLabel.text = @"客户代码";
        khdmLabel.textAlignment = NSTextAlignmentCenter;
        khdmLabel.font = BpcSearchHeaderViewLabelFont;
        [khdmLabel.layer setBorderWidth:borderWidth];
        _khdmLabel = khdmLabel;
        [self addSubview:khdmLabel];
        
        UILabel *khmcLabel = [[UILabel alloc] init];
        khmcLabel.text = @"客户名称";
        khmcLabel.textAlignment = NSTextAlignmentCenter;
        khmcLabel.font = BpcSearchHeaderViewLabelFont;
        [khmcLabel.layer setBorderWidth:borderWidth];
        _khmcLabel = khmcLabel;
        [self addSubview:khmcLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width;
    CGFloat parentH = self.frame.size.height;
    
    CGFloat khdmLabelX = 0;
    CGFloat khdmLabelY = 0;
    CGFloat khdmLabelW = 100;
    CGFloat khdmLabelH = parentH;
    _khdmLabel.frame = CGRectMake(khdmLabelX, khdmLabelY, khdmLabelW, khdmLabelH);
    
    CGFloat khmcLabelX = CGRectGetMaxX(_khdmLabel.frame);
    CGFloat khmcLabelY = 0;
    CGFloat khmcLabelW = parentW - khmcLabelX;
    CGFloat khmcLabelH = parentH;
    _khmcLabel.frame = CGRectMake(khmcLabelX, khmcLabelY, khmcLabelW, khmcLabelH);
}

@end

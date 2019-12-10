//
//  GNCell.m
//  HYWork
//
//  Created by information on 16/3/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "GNCell.h"

@implementation GNCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView  *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _imgView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        _label = label;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imgX = 10;
    CGFloat imgY = 0;
    CGFloat imgW = self.bounds.size.width - 20;
    CGFloat imgH = imgW;
    self.imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    CGFloat labX = 0;
    CGFloat labY = imgH + 5;
    CGFloat labW = self.bounds.size.width;
    CGFloat labH = 15;
    self.label.frame = CGRectMake(labX, labY, labW, labH);
}

- (void)setItem:(Item *)item {
    _item = item;
    
//    if (self.isSelected) {
//        NSString *selectImg = [NSString stringWithFormat:@"%@_hover",item.image];
//        self.imgView.image = [UIImage imageNamed:selectImg];
//    } else {
        self.imgView.image = [UIImage imageNamed:item.image];
//    }
    
    self.label.text = item.title;
}

@end

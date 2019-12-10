//
//  CustomButton.m
//  HYWork
//
//  Created by information on 16/5/26.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "CustomButton.h"
#define IMAGEW 20

@implementation CustomButton

+ (instancetype)customButton {
    CustomButton *btn = [[CustomButton alloc] init];
    return btn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 高亮的时候不要自动调整图片
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeLeft;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius  = 5.0f;
        self.layer.borderColor = GQColor(200.0f, 200.0f, 200.0f).CGColor;
        
        self.backgroundColor = GQColor(240.0f, 240.0f, 240.0f);
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageY = 0;
    CGFloat imageW = IMAGEW;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width - IMAGEW;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setVal:(NSString *)val andDis:(NSString *)dis {
    _val = val;
    _dis = dis;
    [self setTitle:dis forState:UIControlStateNormal];
}

@end

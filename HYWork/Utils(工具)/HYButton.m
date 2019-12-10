//
//  HYButton.m
//  HYWork
//
//  Created by information on 16/6/1.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "HYButton.h"

#define ButtonImageW 20

@implementation HYButton

+ (instancetype)customButton {
    HYButton *btn = [[HYButton alloc] init];
    return btn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 高亮的时候不要自动调整图片
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeLeft;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius  = 5.0f;
        self.layer.borderColor = GQColor(200.0f, 200.0f, 200.0f).CGColor;
        
        self.backgroundColor = GQColor(240.0f, 240.0f, 240.0f);
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

//- (CGRect)imageRectForContentRect:(CGRect)contentRect {
//    CGFloat imageY = 0;
//    CGFloat imageW = ButtonImageW;
//    CGFloat imageX = contentRect.size.width - imageW;
//    CGFloat imageH = contentRect.size.height;
//    return CGRectMake(imageX, imageY, imageW, imageH);
//}
//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect {
//    CGFloat titleX = 0;
//    CGFloat titleY = 0;
//    CGFloat titleW = contentRect.size.width - ButtonImageW;
//    CGFloat titleH = contentRect.size.height;
//    return CGRectMake(titleX, titleY, titleW, titleH);
//}

- (void)setVal:(NSString *)val andDis:(NSString *)dis {
    _val = val;
    _dis = dis;
    [self setTitle:dis forState:UIControlStateNormal];
}

@end
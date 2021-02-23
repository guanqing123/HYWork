//
//  WKNumberScrollView.m
//  HYSmartPlus
//
//  Created by information on 2018/3/14.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKNumberScrollView.h"

@interface WKNumberScrollView()
@property (nonatomic, strong)  NSMutableArray *buttonArray;
@property (nonatomic, strong)  NSTimer *timer;
@end

@implementation WKNumberScrollView

+ (instancetype)scrollView {
    return [[self alloc] init];
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)setScrollArray:(NSArray *)scrollArray {
    [self.buttonArray removeAllObjects];
    for (UIView *child in self.subviews) {
        if ([child isKindOfClass:[UIButton class]]) {
            [child removeFromSuperview];
        }
    }
    [self stopTimer];
    _scrollArray = scrollArray;
    if (scrollArray.count > 0) {
        for (int i = 0; i < scrollArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.numberOfLines = 2;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            [btn setImage:[UIImage imageNamed:@"dots"] forState:UIControlStateNormal];
            [btn setTitle:scrollArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = PFR13Font;
            
            if (i != 0) {
                CATransform3D trans = CATransform3DIdentity;
                trans = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
                trans = CATransform3DTranslate(trans, 0, - self.frame.size.height/2, -self.frame.size.height/2);
                btn.layer.transform = trans;
            }else{
                CATransform3D trans = CATransform3DIdentity;
                trans = CATransform3DMakeRotation(0, 1, 0, 0);
                trans = CATransform3DTranslate(trans, 0, 0, - self.frame.size.height/2);
                btn.layer.transform = trans;
            }
            [self addSubview:btn];
            [self.buttonArray addObject:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.left.equalTo(self);
                make.bottom.equalTo(self);
                make.right.equalTo(self);
            }];
        }
        [self startTimer];
    }
}

#pragma mark - 开始
- (void)startTimer{
    if (!self.interval) {
        self.interval = 5;
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 停止
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 滚动
- (void)timerRun{
    
    if (self.scrollArray.count >1) {
        [UIView animateWithDuration:self.interval/self.interval animations:^{
            
            UIButton *btn = self.buttonArray[0];
            CATransform3D trans = CATransform3DIdentity;
            trans = CATransform3DMakeRotation(-M_PI_2, 1, 0, 0);
            trans = CATransform3DTranslate(trans, 0, self.frame.size.height/2, - self.frame.size.height/2);
            btn.layer.transform = trans;
            
            
            UIButton *btn1 = self.buttonArray[1];
            CATransform3D trans1 = CATransform3DIdentity;
            trans1 = CATransform3DMakeRotation(0, 1, 0, 0);
            trans1 = CATransform3DTranslate(trans1, 0, 0, 0);
            btn1.layer.transform = trans1;
            
        } completion:^(BOOL finished) {
            
            if (finished == YES) {
                UIButton *btn = self.buttonArray[0];
                CATransform3D trans = CATransform3DIdentity;
                trans = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
                trans = CATransform3DTranslate(trans, 0, - self.frame.size.height/2, - self.frame.size.height/2);
                btn.layer.transform = trans;
                
                [self.buttonArray addObject:btn];
                [self.buttonArray removeObjectAtIndex:0];
            }
        }];
    }
}

- (void)dealloc {
    [self stopTimer];
}

- (void)btnAction {
    if ([self.delegate respondsToSelector:@selector(numberScrollViewDidButtonClick:)]) {
        [self.delegate numberScrollViewDidButtonClick:self];
    }
}

@end

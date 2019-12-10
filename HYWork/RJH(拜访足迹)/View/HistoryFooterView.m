//
//  HistoryFooterView.m
//  HYWork
//
//  Created by information on 2017/6/6.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "HistoryFooterView.h"

@interface HistoryFooterView()
/** 顶部横线 */
@property (nonatomic, weak) UIView *topLineView;
/** 清除历史按钮 */
@property (nonatomic, weak) UIButton  *clearHistoryBtn;
/** 底部横线 */
@property (nonatomic, weak) UIView  *bottomLineView;
@end

@implementation HistoryFooterView

+ (instancetype)footerView {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        // 添加顶部横线
        UIView *topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = GQColor(233, 233, 233);
        _topLineView = topLineView;
        [self addSubview:topLineView];
        
        // 清除历史按钮
        UIButton *clearHistoryBtn = [[UIButton alloc] init];
        [clearHistoryBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [clearHistoryBtn setTitle:@"清除历史" forState:UIControlStateNormal];
        [clearHistoryBtn addTarget:self action:@selector(clearHistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _clearHistoryBtn = clearHistoryBtn;
        [self addSubview:clearHistoryBtn];
        
        // 添加底部横线
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = GQColor(233, 233, 233);
        _bottomLineView = bottomLineView;
        [self addSubview:bottomLineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width;
    CGFloat parentH = self.frame.size.height;
    CGFloat lineHeight = 2;
    
    CGFloat topLineViewX = 0;
    CGFloat topLineViewY = 0;
    CGFloat topLineViewW = parentW;
    CGFloat topLineViewH = lineHeight;
    _topLineView.frame = CGRectMake(topLineViewX, topLineViewY, topLineViewW, topLineViewH);
    
    CGFloat clearHistoryBtnX = 0;
    CGFloat clearHistoryBtnY = CGRectGetMaxY(_topLineView.frame);
    CGFloat clearHistoryBtnW = parentW;
    CGFloat clearHistoryBtnH = parentH - 2 * lineHeight;
    _clearHistoryBtn.frame = CGRectMake(clearHistoryBtnX, clearHistoryBtnY, clearHistoryBtnW, clearHistoryBtnH);
    
    CGFloat bottomLineViewX = 0;
    CGFloat bottomLineViewY = CGRectGetMaxY(_clearHistoryBtn.frame);
    CGFloat bottomLineViewW = parentW;
    CGFloat bottomLineViewH = lineHeight;
    _bottomLineView.frame = CGRectMake(bottomLineViewX, bottomLineViewY, bottomLineViewW, bottomLineViewH);
}

- (void)clearHistoryBtnClick {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"rjhBpc"];
    if ([self.delegate respondsToSelector:@selector(footerViewDidReloadTableView:)]) {
        [self.delegate footerViewDidReloadTableView:self];
    }
}

@end

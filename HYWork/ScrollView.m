//
//  ScrollView.m
//  HYWork
//
//  Created by information on 16/4/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)scrollViewCreated:(NSArray *)imgArry {
    if (imgArry.count == 1) {
        _imgArry = [NSMutableArray arrayWithObjects:imgArry[0],imgArry[0],imgArry[0],nil];
    } else if (imgArry.count == 2) {
        _imgArry = [NSMutableArray arrayWithObjects:imgArry[0],imgArry[1],imgArry[0],imgArry[1],nil];
    } else if (imgArry.count > 2) {
        _imgArry = [[NSMutableArray alloc] init];
        [_imgArry addObjectsFromArray:imgArry];
    } else {
        _imgArry = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    }
    
    _scrollView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.imageNameArray = _imgArry;
    _scrollView.PageControlShowStyle = UIPageControlShowStyleRight;
    _scrollView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    _scrollView.pageControl.currentPageIndicatorTintColor = GQColor(0, 157, 133);
    [self addSubview:_scrollView];
    
    //添加一个点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHappened)];
    [_scrollView.centerImageView addGestureRecognizer:tapGesture];
}

- (void)tapHappened {
    if ([self.delegate respondsToSelector:@selector(scrollViewImgClick:)]) {
        [self.delegate scrollViewImgClick:_scrollView.index];
    }
}

@end

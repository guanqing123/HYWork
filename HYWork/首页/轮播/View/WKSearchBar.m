//
//  WKSearchBar.m
//  HYWork
//
//  Created by information on 2018/5/1.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKSearchBar.h"

@implementation WKSearchBar

+ (instancetype)searchBar {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        // 设置光标颜色
        self.tintColor = GQColor(41, 108, 254);
        
        self.textAlignment = NSTextAlignmentLeft;
        self.placeholder = @"搜索条件";
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //设置放大镜图片
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
        leftView.frame = CGRectMake(0, 0, 30, 30);
        leftView.contentMode = UIViewContentModeCenter;
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.font = [UIFont systemFontOfSize:15.0f];
    }
    return self;
}
@end

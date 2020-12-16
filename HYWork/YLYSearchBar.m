//
//  YLYSearchBar.m
//  HYWork
//
//  Created by information on 16/4/18.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "YLYSearchBar.h"

@implementation YLYSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.tintColor = GQColor(41, 108, 254);
        
        self.textAlignment = NSTextAlignmentLeft;
        self.placeholder = @"姓名中文/首字母、部门名称、手机号";
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //设置放大镜图片
        //设置左边的图片永远显示
        self.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
        imageView.frame = CGRectMake(0, 0, 30, 30);
        imageView.contentMode = UIViewContentModeCenter;
        self.leftView = imageView;
        
        self.font = [UIFont systemFontOfSize:15.0f];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

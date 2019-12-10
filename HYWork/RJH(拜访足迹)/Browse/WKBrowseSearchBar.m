//
//  WKBrowseSearchBar.m
//  HYWork
//
//  Created by information on 2018/5/19.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKBrowseSearchBar.h"

@implementation WKBrowseSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.tintColor = GQColor(41, 108, 254);
        
        self.textAlignment = NSTextAlignmentLeft;
        self.placeholder = @"输入员工姓名查询";
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

@end

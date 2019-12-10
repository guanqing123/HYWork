//
//  JdzpView.m
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "JdzpView.h"
#import "UIImageView+WebCache.h"

@implementation JdzpView

- (void)createView:(NSString *)imgUrl titleStr:(NSString *)title
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1.0f, 0.0f, self.frame.size.width - 2.0f, self.frame.size.width / 3 * 2)];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"加载"]];
    
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, _imageView.frame.size.height, self.frame.size.width - 2.0f, 30.0f)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _titleLabel.text = title;
    
    [self addSubview:_titleLabel];
}

@end

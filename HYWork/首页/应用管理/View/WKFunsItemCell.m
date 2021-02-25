//
//  WKFunsItemCell.m
//  HYWork
//
//  Created by information on 2021/1/13.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKFunsItemCell.h"

//category
#import "UIColor+DCColorChange.h"
//tool
#import "SPSpeedy.h"
#import "SDWebImage.h"

@interface WKFunsItemCell ()

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *rightUpperButton;

@end

@implementation WKFunsItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat containerX = 10;
        CGFloat containerY = 5;
        CGFloat containerW = self.bounds.size.width - 2 * containerX;
        CGFloat containerH = self.bounds.size.height - 2 * containerY;
        _container = [[UIView alloc] initWithFrame:CGRectMake(containerX, containerY, containerW, containerH)];
        _container.backgroundColor = [UIColor whiteColor];
        _container.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _container.layer.borderColor = [UIColor colorWithRed:232 / 255.0 green:232 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake((containerW - 40) / 2, 6, 40, 40)];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_icon.frame), containerW, containerH - CGRectGetMaxY(_icon.frame))];
        _titleLabel.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _rightUpperButton = [[UIButton alloc] initWithFrame:CGRectMake(containerW - 40 / 2 - 11.5 / 2 - 2, -20 + 11.5 / 2 + 2, 40, 40)];
        [_rightUpperButton addTarget:self action:@selector(rightUpperButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_container addSubview:_icon];
        [_container addSubview:_titleLabel];
        [_container addSubview:_rightUpperButton];
        [self.contentView addSubview:_container];
        
    }
    return self;
}

- (void)setHomeWork:(WKHomeWork *)homeWork {
    _homeWork = homeWork;
    
    // 0.图标
    if ([_homeWork.iconImage isEqualToString:@"https://honyar.oss-cn-hangzhou.aliyuncs.com/hywork/txl.png"]) {
        _homeWork.iconImage = @"txl";
    }
    if ([_homeWork.iconImage length] > 4 && [[_homeWork.iconImage substringToIndex:4] isEqualToString:@"http"]) {
        if ([WKHttpTool pifu]) {
            NSString *prefix = [_homeWork.iconImage substringToIndex:[_homeWork.iconImage rangeOfString:@"." options:NSBackwardsSearch].location];
            NSString *suffix = [_homeWork.iconImage substringFromIndex:[_homeWork.iconImage rangeOfString:@"." options:NSBackwardsSearch].location];
            [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@o%@", prefix, suffix]]];
        } else {
            [_icon sd_setImageWithURL:[NSURL URLWithString:_homeWork.iconImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
    } else {
        if ([WKHttpTool pifu]) {
            _icon.image = [UIImage imageNamed:[_homeWork.iconImage stringByAppendingString:@"o"]];
        } else {
            _icon.image = [UIImage imageNamed:_homeWork.iconImage];
        }
    }
    
    // 1.标题
    _titleLabel.text = _homeWork.gridTitle;
    
    // 2.角标
    switch (_homeWork.hystatus) {
        case HYStatusMinusSign:
            [_rightUpperButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
            break;
        case HYStatusPlusSign:
            [_rightUpperButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
            break;
        case HYStatusCheck:
            [_rightUpperButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)setIsEditing:(BOOL)isEditing {
    _rightUpperButton.hidden = !isEditing;
    if (isEditing) {
        _container.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    }else {
        _container.layer.borderWidth = 0.0;
    }
}

- (void)rightUpperButtonAction {
    if ([self.delegate respondsToSelector:@selector(rightUpperButtonDidTappedWithItemCell:)]) {
        [self.delegate rightUpperButtonDidTappedWithItemCell:self];
    }
}

@end

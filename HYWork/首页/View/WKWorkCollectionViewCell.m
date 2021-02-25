//
//  WKWorkCollectionViewCell.m
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKWorkCollectionViewCell.h"

//category
#import "UIColor+DCColorChange.h"
//tool
#import "SPSpeedy.h"
#import "SDWebImage.h"

@interface WKWorkCollectionViewCell()

/* imageView */
@property (strong , nonatomic)UIImageView *gridImageView;
/* gridLabel */
@property (strong , nonatomic)UILabel *gridLabel;
/* tagLabel */
@property (strong , nonatomic)UILabel *tagLabel;

@end

@implementation WKWorkCollectionViewCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    // 1.图片
    _gridImageView = [[UIImageView alloc] init];
    _gridImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_gridImageView];
    
    // 2.标题
    _gridLabel = [[UILabel alloc] init];
    _gridLabel.font = PFR13Font;
    _gridLabel.textAlignment = NSTextAlignmentCenter;
    _gridLabel.textColor = GQColor(110, 110, 110);
    [self addSubview:_gridLabel];
    
    // 3.角标
    _tagLabel = [[UILabel alloc] init];
    _tagLabel.font = [UIFont systemFontOfSize:8];
    _tagLabel.backgroundColor = [UIColor whiteColor];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tagLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self)setOffset:WKMargin];
        if (bigScreen) {
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }else{
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }
        make.centerX.mas_equalTo(self);
    }];
    
    [_gridLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(_gridImageView.mas_bottom)setOffset:5];
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_gridImageView.mas_right);
        make.centerY.mas_equalTo(_gridImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(20, 15));
    }];
}

#pragma mark - Setter Getter Methods
- (void)setHomeWork:(WKHomeWork *)homeWork {
    _homeWork = homeWork;
    
    _gridLabel.text = homeWork.gridTitle;
    _tagLabel.text = homeWork.gridTag;
    
    _tagLabel.hidden = (homeWork.gridTag.length == 0) ? YES : NO;
    _tagLabel.textColor = [UIColor dc_colorWithHexString:homeWork.gridColor];
    [SPSpeedy dc_chageControlCircularWith:_tagLabel AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:_tagLabel.textColor canMasksToBounds:YES];
    
    if (_homeWork.iconImage.length == 0) return;
    if ([_homeWork.iconImage isEqualToString:@"https://honyar.oss-cn-hangzhou.aliyuncs.com/hywork/txl.png"]) {
        _homeWork.iconImage = @"txl";
    }
    if ([_homeWork.iconImage length] > 4 && [[_homeWork.iconImage substringToIndex:4] isEqualToString:@"http"]) {
        if ([WKHttpTool pifu]) {
            NSString *prefix = [_homeWork.iconImage substringToIndex:[_homeWork.iconImage rangeOfString:@"." options:NSBackwardsSearch].location];
            NSString *suffix = [_homeWork.iconImage substringFromIndex:[_homeWork.iconImage rangeOfString:@"." options:NSBackwardsSearch].location];
            [_gridImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@o%@", prefix, suffix]]];
        } else {
            [_gridImageView sd_setImageWithURL:[NSURL URLWithString:_homeWork.iconImage]];
        }
    } else {
        if ([WKHttpTool pifu]) {
            _gridImageView.image = [UIImage imageNamed:[_homeWork.iconImage stringByAppendingString:@"o"]];
        } else {
            _gridImageView.image = [UIImage imageNamed:_homeWork.iconImage];
        }
    }
}

@end

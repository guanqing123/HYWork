//
//  ZjxsCheckCell.m
//  HYWork
//
//  Created by information on 16/6/12.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "ZjxsCheckCell.h"

@interface ZjxsCheckCell()
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UILabel  *titleLabel;
@property (nonatomic, weak) UIImageView  *shenpiImgView;
@end

@implementation ZjxsCheckCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"zjxsCheckCell";
    ZjxsCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZjxsCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(10, 10, 20, 20);
        _imgView = imgView;
        [self.contentView addSubview:imgView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(40, 0, SCREEN_WIDTH - 40, 43.0f);
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        
        UIImageView *shenpiImgView = [[UIImageView alloc] init];
        [shenpiImgView setImage:[UIImage imageNamed:@"shenpi"]];
        shenpiImgView.frame = CGRectMake(SCREEN_WIDTH - 40, 7, 30, 30);
        _shenpiImgView = shenpiImgView;
        [self.contentView addSubview:shenpiImgView];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 43.0f, SCREEN_WIDTH, 1.0f);
        lineView.backgroundColor = GQColor(192.0f, 192.0f, 192.0f);
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setZjxs:(ZJXS *)zjxs {
    _zjxs = zjxs;
    
    if (zjxs.flag) {
        [self.imgView setImage:[UIImage imageNamed:@"home_func_unselect"]];
    }else{
        [self.imgView setImage:nil];
    }
    
    if ([zjxs.xzzj intValue] < 3) {
        self.shenpiImgView.hidden = YES;
    }
    
    [self.titleLabel setText:zjxs.ygxm];
}

@end

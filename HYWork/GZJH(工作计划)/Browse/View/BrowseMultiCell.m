//
//  BrowseMultiCell.m
//  HYWork
//
//  Created by information on 16/5/31.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BrowseMultiCell.h"

@interface BrowseMultiCell()
@property (nonatomic, weak) UILabel  *ygxmLabel;
@property (nonatomic, weak) UILabel  *zwsmLabel;
@property (nonatomic, weak) UILabel  *mobileLabel;
@property (nonatomic, weak) UIButton  *imgBtn;
@end

@implementation BrowseMultiCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"BrowseMultiCell";
    BrowseMultiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BrowseMultiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *ygxmLabel = [[UILabel alloc] init];
        _ygxmLabel = ygxmLabel;
        ygxmLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:ygxmLabel];
        
        UILabel *zwsmLabel = [[UILabel alloc] init];
        _zwsmLabel = zwsmLabel;
        zwsmLabel.font = [UIFont systemFontOfSize:14];
        zwsmLabel.textColor = GQColor(150.0f, 150.0f, 150.0f);
        [self.contentView addSubview:zwsmLabel];
        
        UILabel *mobileLabel = [[UILabel alloc] init];
        _mobileLabel = mobileLabel;
        mobileLabel.font = [UIFont systemFontOfSize:14];
        mobileLabel.textColor = GQColor(150.0f, 150.0f, 150.0f);
        [self.contentView addSubview:mobileLabel];
        
        UIButton *imgBtn = [[UIButton alloc] init];
        imgBtn.adjustsImageWhenHighlighted = NO;
        imgBtn.contentMode = UIViewContentModeCenter;
        [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imgBtn = imgBtn;
        [self.contentView addSubview:imgBtn];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
        lineView.frame = CGRectMake(0, 66, SCREEN_WIDTH, 1);
        [self.contentView addSubview:lineView];
    }
    return self;
}


- (void)setDict:(NSDictionary *)dict {
    // 1.给模型赋值
    _dict = dict;
    
    // 2.给字段赋值
    self.ygbm = dict[@"ygbm"];
    
    self.ygxmLabel.text = dict[@"ygxm"];
    
    self.mobileLabel.text = dict[@"mobile"];
    
    self.zwsmLabel.text = [NSString stringWithFormat:@"%@/%@",dict[@"bmmc"],dict[@"zwsm"]];
    
}

- (void)setChoosed:(BOOL)choosed {
    _choosed = choosed;
    if (choosed) {
        [_imgBtn setImage:[UIImage imageNamed:@"plan_select"] forState:UIControlStateNormal];
    }else{
        [_imgBtn setImage:[UIImage imageNamed:@"plan_unselect"] forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat paddingX = 10;
    CGFloat paddingY = 0;
    
    CGFloat ygxmW = SCREEN_WIDTH / 4;
    CGFloat ygxmH = 36;
    _ygxmLabel.frame = CGRectMake(paddingX, paddingY, ygxmW, ygxmH);
    
    CGFloat mobileX = paddingX + ygxmW;
    CGFloat mobileW = SCREEN_WIDTH / 2;
    CGFloat mobileH = 36;
    _mobileLabel.frame = CGRectMake(mobileX, paddingY, mobileW, mobileH);
    
    CGFloat zwsmY = ygxmH;
    CGFloat zwsmW = ygxmW + mobileW;
    CGFloat zwsmH = 30;
    _zwsmLabel.frame = CGRectMake(paddingX, zwsmY, zwsmW, zwsmH);
    
    CGFloat height = self.frame.size.height;
    CGFloat padding = 25.0f;
    CGFloat imgW = 20.0f;
    CGFloat imgH = height;
    CGFloat imgX = SCREEN_WIDTH - imgW - padding;
    CGFloat imgY = 0.0f;
    _imgBtn.frame = CGRectMake(imgX, imgY, imgW, imgH);
}

+ (CGFloat)getCellHeight {
    return 67;
}

- (void)imgBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(browseMultiCellDidClickCell:)]) {
        [self.delegate browseMultiCellDidClickCell:self];
    }
}

@end

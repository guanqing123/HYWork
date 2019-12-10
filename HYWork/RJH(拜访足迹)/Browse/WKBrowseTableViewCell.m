//
//  WKBrowseTableViewCell.m
//  HYWork
//
//  Created by information on 2018/5/19.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKBrowseTableViewCell.h"

@interface WKBrowseTableViewCell()

@property (nonatomic, weak) UILabel  *ygxmLabel;
@property (nonatomic, weak) UILabel  *zwsmLabel;
@property (nonatomic, weak) UILabel  *mobileLabel;
@property (nonatomic, strong)  UIWebView *webView;

@end

@implementation WKBrowseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"WKBrowseTableViewCellID";
    WKBrowseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WKBrowseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
        lineView.frame = CGRectMake(0, 66, SCREEN_WIDTH, 1);
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

- (void)setYgxm:(NSString *)ygxm {
    _ygxm = ygxm;
    _ygxmLabel.text = ygxm;
}

- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;
    _mobileLabel.text = mobile;
}

- (void)setZwsm:(NSString *)zwsm {
    _zwsm = zwsm;
    _zwsmLabel.text = zwsm;
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
}

+ (CGFloat)getCellHeight {
    return 67;
}

@end

//
//  WKAddressListTableViewCell.m
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKAddressListTableViewCell.h"

@interface WKAddressListTableViewCell()
// 员工姓名
@property (nonatomic, weak) UILabel  *ygxmLabel;
// 职位说明
@property (nonatomic, weak) UILabel  *zwsmLabel;
// 手机号
@property (nonatomic, weak) UILabel  *mobileLabel;
// 打电话
@property (nonatomic, strong)  UIWebView *webView;
@end

@implementation WKAddressListTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"WKAddressListTableViewCellID";
    WKAddressListTableViewCell *addressListCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (addressListCell == nil) {
        addressListCell = [[WKAddressListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return addressListCell;
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
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH - 60, 18, 30, 30);
        [btn setImage:[UIImage imageNamed:@"mobile"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(telephone) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
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

- (void)telephone {
    if (_mobile == nil) return;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_mobile]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
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

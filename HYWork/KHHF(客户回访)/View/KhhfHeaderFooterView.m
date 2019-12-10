//
//  KhhfHeaderFooterView.m
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "KhhfHeaderFooterView.h"

@interface KhhfHeaderFooterView()

@property (nonatomic, weak) UILabel  *khdmLabel;

@property (nonatomic, weak) UILabel  *khmcLabel;

@end

@implementation KhhfHeaderFooterView

+ (instancetype)sectionHeaderView:(UITableView *)tableView {
    static NSString *ID = @"khkfHeaderFooterViewID";
    KhhfHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headerView == nil) {
        headerView = [[KhhfHeaderFooterView alloc] initWithReuseIdentifier:ID];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UILabel *khdmLabel = [[UILabel alloc] init];
        khdmLabel.text = @"客户代码";
        khdmLabel.textAlignment = NSTextAlignmentCenter;
        _khdmLabel = khdmLabel;
        [self.contentView addSubview:khdmLabel];
        [khdmLabel.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [khdmLabel.layer setBorderWidth:0.5];
        
        UILabel *khmcLabel = [[UILabel alloc] init];
        khmcLabel.text = @"客户名称";
        khmcLabel.textAlignment = NSTextAlignmentCenter;
        _khmcLabel = khmcLabel;
        [self.contentView addSubview:khmcLabel];
        [khmcLabel.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [khmcLabel.layer setBorderWidth:0.5];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width;
    CGFloat parentH = self.frame.size.height;
    
    self.khdmLabel.frame = CGRectMake(0, 0, 80, parentH);
    
    CGFloat khmcLabelX = CGRectGetMaxX(self.khdmLabel.frame);
    self.khmcLabel.frame = CGRectMake(khmcLabelX, 0, parentW - khmcLabelX, parentH);
}

@end

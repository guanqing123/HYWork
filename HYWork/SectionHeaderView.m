//
//  SectionHeaderView.m
//  HYWork
//
//  Created by information on 16/4/15.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "SectionHeaderView.h"

@interface SectionHeaderView()

@property (nonatomic, strong) UILabel  *headerLabel;

@end

@implementation SectionHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 25);
        self.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
        
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.frame = CGRectMake(15, 0, 200, 25);
        _headerLabel.textColor = [UIColor grayColor];
        _headerLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_headerLabel];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    _headerLabel.text = text;
}

+ (CGFloat)getSectionHeadHeight {
    return 25.0f;
}

@end



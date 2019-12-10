//
//  DkHeaderView.m
//  HYWork
//
//  Created by information on 16/3/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DkHeaderView.h"
#import "PubLabel.h"

#define headerViewFont [UIFont boldSystemFontOfSize:15.0f]

@implementation DkHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        PubLabel *khdmLabel = [PubLabel labelWithFont:headerViewFont];
        _khdmLabel = khdmLabel;
        [self addSubview:khdmLabel];
        
        PubLabel *khmcLabel = [PubLabel labelWithFont:headerViewFont];
        _khmcLabel = khmcLabel;
        [self addSubview:khmcLabel];
        
        PubLabel *dkdhLabel = [PubLabel labelWithFont:headerViewFont];
        _dkdhLabel = dkdhLabel;
        [self addSubview:dkdhLabel];
        
        PubLabel *dkddLabel = [PubLabel labelWithFont:headerViewFont];
        _dkddLabel = dkddLabel;
        [self addSubview:dkddLabel];
        
        PubLabel *hzddLabel = [PubLabel labelWithFont:headerViewFont];
        _hzddLabel = hzddLabel;
        [self addSubview:hzddLabel];
        
        PubLabel *zjrqLabel = [PubLabel labelWithFont:headerViewFont];
        _zjrqLabel = zjrqLabel;
        [self addSubview:zjrqLabel];
        
        PubLabel *jeLabel = [PubLabel labelWithFont:headerViewFont];
        _jeLabel = jeLabel;
        [self addSubview:jeLabel];
        
        PubLabel *ztLabel = [PubLabel labelWithFont:headerViewFont];
        _ztLabel = ztLabel;
        [self addSubview:ztLabel];
        
        PubLabel *syhbLabel = [PubLabel labelWithFont:headerViewFont];
        _syhbLabel = syhbLabel;
        [self addSubview:syhbLabel];
        
        PubLabel *syhbbmLabel = [PubLabel labelWithFont:headerViewFont];
        _syhbbmLabel = syhbbmLabel;
        [self addSubview:syhbbmLabel];
    }
    return self;
}

+ (instancetype)headerView:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.khdmLabel.frame = CGRectMake(0.0f, 0.0f, 80.0f, 44.0f);
    self.khdmLabel.text = @"客户代码";
    
    self.khmcLabel.frame = CGRectMake(80.0f, 0.0f, 120.0f, 44.0f);
    self.khmcLabel.text = @"客户名称";
    
    self.dkdhLabel.frame = CGRectMake(200.0f, 0.0f, 150.0f, 44.0f);
    self.dkdhLabel.text = @"到款单号";
    
    self.dkddLabel.frame = CGRectMake(350.0f, 0.0f, 200.0f, 44.0f);
    self.dkddLabel.text = @"到款地点";
    
    self.hzddLabel.frame = CGRectMake(550.0f, 0.0f, 200.0f, 44.0f);
    self.hzddLabel.text = @"划至地点";
    
    self.zjrqLabel.frame = CGRectMake(750.0f, 0.0f, 100.0f, 44.0f);
    self.zjrqLabel.text = @"记账日期";
    
    self.jeLabel.frame = CGRectMake(850.0f, 0.0f, 80.0f, 44.0f);
    self.jeLabel.text = @"金额";
    
    self.ztLabel.frame = CGRectMake(930.0f, 0.0f, 100.0f, 44.0f);
    self.ztLabel.text = @"状态";
    
    self.syhbLabel.frame = CGRectMake(1030.0f, 0.0f, 100.0f, 44.0f);
    self.syhbLabel.text = @"销售代表";
    
    self.syhbbmLabel.frame = CGRectMake(1130.0f, 0.0f, 150.0f, 44.0f);
    self.syhbbmLabel.text = @"部门";
}

@end

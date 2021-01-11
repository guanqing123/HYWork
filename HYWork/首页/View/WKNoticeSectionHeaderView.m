//
//  WKNoticeSectionHeaderView.m
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKNoticeSectionHeaderView.h"
#import "WKHomeTool.h"

// 跑马灯
#import <JhtMarquee/JhtVerticalMarquee.h>

@interface WKNoticeSectionHeaderView()

@property (weak, nonatomic) IBOutlet UIView *marqueeF;

@property (nonatomic, strong)  JhtVerticalMarquee *verticalMarquee;

@property (nonatomic, strong)  NSArray *notices;

@property (nonatomic, assign) BOOL loaded;

@property (nonatomic, assign) BOOL pauseV;

@end

@implementation WKNoticeSectionHeaderView

+ (instancetype)sectionHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WKNoticeSectionHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.marqueeF addSubview:self.verticalMarquee];
    [self loadData];
}

- (JhtVerticalMarquee *)verticalMarquee {
    if (!_verticalMarquee) {
        _verticalMarquee = [[JhtVerticalMarquee alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 44, self.marqueeF.dc_height)];
        _verticalMarquee.textColor = GQColor(110, 110, 110);
        _verticalMarquee.textAlignment = NSTextAlignmentLeft;
        _verticalMarquee.scrollDuration = 1.5f;
        _verticalMarquee.scrollDelay = 4.0f;
        _verticalMarquee.numberOfLines = 1;
        
        // 添加点击手势
        UITapGestureRecognizer *htap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marqueeTapGes:)];
        [_verticalMarquee addGestureRecognizer:htap];
    }
    return _verticalMarquee;
}

- (void)marqueeTapGes:(UITapGestureRecognizer *)ges {
    [self stop];
    WKHomeNotice *notice = [self.notices objectAtIndex:self.verticalMarquee.currentIndex];
    if ([self.delegate respondsToSelector:@selector(headerViewDidClick:currentNoticeId:)]) {
        [self.delegate headerViewDidClick:self currentNoticeId:notice.noticeId];
    }
}

- (void)loadData {
    WKHomeNoticeParam *param = [[WKHomeNoticeParam alloc] init];
    param.limit = 5;
    param.page = 1;
    [WKHomeTool getHomeNotices:param success:^(WKHomeNoticeResult * _Nonnull result) {
        if (result.code != 200) {
            [SVProgressHUD showErrorWithStatus:result.message];
        } else {
            self.notices = result.data;
            NSMutableArray *titleArray = [NSMutableArray array];
            [result.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WKHomeNotice *notice = obj;
                [titleArray addObject:notice.title];
            }];
            self.verticalMarquee.sourceArray = titleArray;
            _loaded = YES;
            [self zstart];
        }
    } failure:^(NSError * _Nonnull error) {
         [SVProgressHUD showErrorWithStatus:@"请求失败,稍微再试"];
    }];
}

- (void)zstart {
    [self.verticalMarquee marqueeOfSettingWithState:MarqueeStart_V];
    _pauseV = NO;
}

- (void)start {
    if (_loaded && _pauseV) {
        [self.verticalMarquee marqueeOfSettingWithState:MarqueeStart_V];
        _pauseV = NO;
    }
}

- (void)stop {
    [self.verticalMarquee marqueeOfSettingWithState:MarqueePause_V];
    _pauseV = YES;
}

@end

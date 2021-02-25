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
#import "WKNumberScrollView.h"

@interface WKNoticeSectionHeaderView()<WKNumberScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *marqueeF;

@property (nonatomic, strong)  WKNumberScrollView *numberScrollView;

@property (nonatomic, strong)  NSArray *notices;

@property (nonatomic, assign) BOOL loaded;

@property (nonatomic, assign) BOOL pauseV;

- (IBAction)moreNotice;

@end

@implementation WKNoticeSectionHeaderView

+ (instancetype)sectionHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WKNoticeSectionHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.marqueeF addSubview:self.numberScrollView];
    [self.numberScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.marqueeF);
    }];
    
    [self loadData];
}

- (WKNumberScrollView *)numberScrollView {
    if (!_numberScrollView) {
        _numberScrollView = [WKNumberScrollView scrollView];
        _numberScrollView.delegate = self;
    }
    return _numberScrollView;
}

- (void)numberScrollViewDidButtonClick:(WKNumberScrollView *)numberScrollView {
    if ([self.delegate respondsToSelector:@selector(headerViewDidClick:)]) {
        [self.delegate headerViewDidClick:self];
    }
}

- (IBAction)moreNotice {
    if ([self.delegate respondsToSelector:@selector(headerViewDidClick:)]) {
        [self.delegate headerViewDidClick:self];
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
            [self.numberScrollView setScrollArray:titleArray];
        }
    } failure:^(NSError * _Nonnull error) {
         [SVProgressHUD showErrorWithStatus:@"请求失败,稍微再试"];
    }];
}

@end

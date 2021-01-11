//
//  WKSliderHeaderView.m
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKSliderHeaderView.h"
#import "DGActivityIndicatorView.h"
#import "SDCycleScrollView.h"
#import "WKHomeTool.h"

@interface WKSliderHeaderView()<SDCycleScrollViewDelegate>
/* 指示器 */
@property (nonatomic, strong)  DGActivityIndicatorView *indicatorView;
/* 轮播图 */
@property (nonatomic, strong)  SDCycleScrollView *cycleScrollView;
/* 刷新页面 */
@property (nonatomic, strong)  UIView *refreshView;
/* 轮播图 */
@property (nonatomic, strong)  NSArray *sliders;
@end

@implementation WKSliderHeaderView

#pragma mark - 初始化
+ (instancetype)headerView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 1.指示器
        [self addSubview:self.indicatorView];
        // 2.滚动页
        [self addSubview:self.cycleScrollView];
        // 3.添加刷新按钮
        [self addSubview:self.refreshView];
        // 4.加载数据
        [self loadData];
    }
    return self;
}

#pragma mark - 指示器
- (DGActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScalePulseOut tintColor:[UIColor lightGrayColor] size:30.0f];
    }
    return _indicatorView;
}

#pragma mark - 滚动页
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"slide_backgroud_icon"]];
        _cycleScrollView.alpha = 0;
        _cycleScrollView.delegate = self;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.autoScrollTimeInterval = 5.0;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    }
    return _cycleScrollView;
}

#pragma mark - 刷新页
- (UIView *)refreshView {
    if (!_refreshView) {
        _refreshView = [[UIView alloc] init];
        _refreshView.alpha = 0;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"世界上最遥远的距离就是断网";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = GQColor(85, 85, 85);
        titleLabel.font = PFR12Font;
        [_refreshView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_refreshView);
            make.bottom.mas_equalTo(_refreshView.mas_centerY).offset(-WKMargin/2);
            make.width.equalTo(_refreshView);
            make.height.mas_equalTo(16);
        }];
        
        UIButton *refreshBtn = [[UIButton alloc] init];
        [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        refreshBtn.titleLabel.font = PFR10Font;
        [refreshBtn setImage:[UIImage imageNamed:@"slide_refresh_icon"] forState:UIControlStateNormal];
        refreshBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        refreshBtn.backgroundColor = [UIColor lightGrayColor];
        refreshBtn.layer.cornerRadius = 10;
        [refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_refreshView addSubview:refreshBtn];
        [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 20));
            make.centerX.equalTo(_refreshView);
            make.top.mas_equalTo(_refreshView.mas_centerY).offset(WKMargin/2);
        }];
    }
    return _refreshView;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
    }];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
    }];
    [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - loadData
- (void)loadData {
    self.refreshView.alpha = 0;
    self.cycleScrollView.alpha = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0 animations:^{
        [weakSelf.indicatorView startAnimating];
    }];
    
    WKHomeSliderParam *param = [[WKHomeSliderParam alloc] init];
    param.isTop = 1;
    param.limit = 5;
    param.page = 0;
    [WKHomeTool getHomeSliders:param success:^(WKHomeSliderResult * _Nonnull result) {
        [weakSelf.indicatorView stopAnimating];
        if (result.code != 200) {
            [SVProgressHUD showErrorWithStatus:result.message];
            [UIView animateWithDuration:2.0 animations:^{
                weakSelf.refreshView.alpha = 1;
            }];
        } else {
            _sliders = result.data;
            NSMutableArray *imageURLArray = [NSMutableArray array];
            NSMutableArray *titleArray = [NSMutableArray array];
            [result.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WKHomeSlider *slider = obj;
                [imageURLArray addObject:slider.carouselImgUrl];
                [titleArray addObject:slider.title];
            }];
            weakSelf.cycleScrollView.imageURLStringsGroup = imageURLArray;
            weakSelf.cycleScrollView.titlesGroup = titleArray;
            [UIView animateWithDuration:2.0 animations:^{
                weakSelf.cycleScrollView.alpha = 1;
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.indicatorView stopAnimating];
        [UIView animateWithDuration:1.0 animations:^{
            weakSelf.refreshView.alpha = 1;
        }];
    }];
}

- (void)refreshBtnClick {
    [self loadData];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    WKHomeSlider *slider = [self.sliders objectAtIndex:index];
    !_sliderClickBlock ? : _sliderClickBlock(slider);
}

@end

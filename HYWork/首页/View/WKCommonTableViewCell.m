//
//  WKCommonTableViewCell.m
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKCommonTableViewCell.h"

// view
#import "WKWorkCollectionViewCell.h"

@interface WKCommonTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong)  UICollectionView *collectionView;

@end

static NSString *const WKWorkCollectionViewCellID = @"WKWorkCollectionViewCell";

@implementation WKCommonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - lazyLoad
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[WKWorkCollectionViewCell class] forCellWithReuseIdentifier:WKWorkCollectionViewCellID];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(_bottomView.mas_top);
        make.top.mas_equalTo(_topView.mas_bottom);
    }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _commons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WKWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WKWorkCollectionViewCellID forIndexPath:indexPath];
    
    cell.homeWork = _commons[indexPath.row];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WKHomeWork  *homeWork =  _commons[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(commonTableViewCell:didClickCollectionViewItem:)]) {
        [self.delegate commonTableViewCell:self didClickCollectionViewItem:homeWork];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH / 4, 85);
}

@end

//
//  WKDefineTableViewCell.m
//  HYWork
//
//  Created by information on 2021/1/13.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKDefineTableViewCell.h"

// view
#import "WKWorkCollectionViewCell.h"

@interface WKDefineTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, strong)  UICollectionView *collectionView;

@end

static NSString *const WKWorkCollectionViewCellID = @"WKWorkCollectionViewCell";

@implementation WKDefineTableViewCell

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
        make.bottom.mas_equalTo(self);
        make.top.mas_equalTo(_topView.mas_bottom);
    }];
}

- (void)setDefines:(NSMutableArray<WKHomeWork *> *)defines {
    _defines = defines;
    
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _defines.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WKWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WKWorkCollectionViewCellID forIndexPath:indexPath];
    
    cell.homeWork = _defines[indexPath.row];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WKHomeWork  *homeWork =  _defines[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(defineTableViewCell:didClickCollectionViewItem:)]) {
        [self.delegate defineTableViewCell:self didClickCollectionViewItem:homeWork];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH / 4, 85);
}

@end

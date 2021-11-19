//
//  WKFunsViewController.m
//  HYWork
//
//  Created by information on 2021/1/12.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKFunsViewController.h"
#import "LYConstans.h"

// view
#import "WKFunsItemCell.h"
#import "WKFunsItemHeaderView.h"

// tool
#import "WKFunsTool.h"

static NSString *cellID = @"WKFunsItemCell";
static NSString *headerViewID = @"WKFunsItemHeaderView";

@interface WKFunsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WKFunsItemCellDelegate> {
    NSIndexPath *_originalIndexPath;
    NSIndexPath *_moveIndexPath;
    UIView *_snapshotView;
}

/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

/** 编辑状态 */
@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, strong) NSMutableArray *itemGroups;

@property (nonatomic, strong) NSArray *allItemModel;

@end

@implementation WKFunsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.Nav
    [self setupNav];
    
    // 2.collectionView
    [self setupCollectionView];
    
    // 3.loadData
    [self loadData];
}

#pragma mark - 设置导航栏
- (void)setupNav {
    // title
    self.title = @"管理我的应用";
    
    // 左侧导航
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 右侧导航
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = PFR15Font;
    [button setTitle:@"管理" forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateSelected];
    [button sizeToFit];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(managerAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *managerItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = managerItem;
    
    //主动触发按钮
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)back {
    // 防止操作了,忘记点右上角完成按钮
    if (self.isEditing && [self.itemGroups count] > 0) {
        WKHomeWorkGroup *itemGroup = self.itemGroups[0];
        [NSKeyedArchiver archiveRootObject:itemGroup.items toFile:DEFINES];
        
        // 刷新本地自定义模块
        [[NSNotificationCenter defaultCenter] postNotificationName:refreshDefines object:nil userInfo:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)managerAction:(UIButton *)managerButton {
    managerButton.selected = !managerButton.selected;
    self.isEditing = managerButton.selected;
    [self.collectionView reloadData];
    
    if (!self.isEditing && [self.itemGroups count] > 0) {
        WKHomeWorkGroup *itemGroup = self.itemGroups[0];
        [NSKeyedArchiver archiveRootObject:itemGroup.items toFile:DEFINES];
        
        // 刷新本地自定义模块
        [[NSNotificationCenter defaultCenter] postNotificationName:refreshDefines object:nil userInfo:nil];
    }
}

- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    UIBarButtonItem *rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    UIButton *managerButton = rightBarButtonItem.customView;
    managerButton.selected = isEditing;
}

#pragma mark - setupCollectionView
- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 35);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[WKFunsItemCell class] forCellWithReuseIdentifier:cellID];
    [_collectionView registerClass:[WKFunsItemHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [_collectionView addGestureRecognizer:longPress];

}

#pragma mark - loadData
- (NSMutableArray *)itemGroups {
    if (!_itemGroups) {
        _itemGroups = [NSMutableArray array];
    }
    return _itemGroups;
}
- (void)loadData {
    [SVProgressHUD show];
    [WKFunsTool getHomeWork:^(WKHomeWorkResult * _Nonnull result) {
        [SVProgressHUD dismiss];
        if (result.code != 200) {
            [SVProgressHUD showErrorWithStatus:result.message];
        } else {
            // 加载全部功能
            [self.itemGroups addObjectsFromArray:result.data];
            
            // 加载本地功能
            WKHomeWorkGroup *itemGroup = [[WKHomeWorkGroup alloc] init];
            NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithFile:DEFINES];
            itemGroup.type = @"首页快捷入口--(此模块长按可以调整顺序)";
            itemGroup.items = [NSMutableArray array];
            if ([items count] > 0) {
                [itemGroup.items addObjectsFromArray:items];
            }
            [self.itemGroups insertObject:itemGroup atIndex:0];
            
            // 加工数据
            NSMutableArray *allItemModels = [[NSMutableArray alloc] init];
            for (WKHomeWorkGroup *group in self.itemGroups) {
                if ([group.type isEqualToString:@"首页快捷入口--(此模块长按可以调整顺序)"]) {
                    for (WKHomeWork *item in group.items) {
                        item.hystatus = HYStatusMinusSign;
                    }
                } else {
                    [allItemModels addObjectsFromArray:group.items];
                }
            }
            self->_allItemModel = [allItemModels copy];
            [self.collectionView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求异常,稍后再试"];
    }];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.itemGroups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    WKHomeWorkGroup *group = self.itemGroups[section];
    return group.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WKFunsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    WKHomeWorkGroup *group = self.itemGroups[indexPath.section];
    WKHomeWork *itemModel = group.items[indexPath.row];
    if (indexPath.section != 0) {
        BOOL isAdded = NO;
        WKHomeWorkGroup *homeGroup = self.itemGroups[0];
        for (WKHomeWork *homeItemModel in homeGroup.items) {
            
            if ([homeItemModel.gridTitle isEqualToString:itemModel.gridTitle]) {
                isAdded = YES;
                break;
            }
        }
        
        if (isAdded) {
            itemModel.hystatus = HYStatusCheck;
        } else {
            itemModel.hystatus = HYStatusPlusSign;
        }
    }
    cell.isEditing = _isEditing;
    cell.homeWork = group.items[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        WKFunsItemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        
        WKHomeWorkGroup *group = self.itemGroups[indexPath.section];
        headerView.title = group.type;

        return headerView;
    }else {
        return nil;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 10, 0);
    }else {
        return UIEdgeInsetsMake(0, 0, 1 / [UIScreen mainScreen].scale, 0);
    }
}

#pragma mark - longPressAction(长按手势)
- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self.collectionView];
    _moveIndexPath = [self.collectionView indexPathForItemAtPoint:touchPoint];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isEditing == NO) {
                self.isEditing = YES;
                [self.collectionView reloadData];
                [self.collectionView layoutIfNeeded];
            }
            if (_moveIndexPath.section == 0) {
                WKFunsItemCell *selectedItemCell = (WKFunsItemCell *)[self.collectionView cellForItemAtIndexPath:_moveIndexPath];
                _originalIndexPath = [self.collectionView indexPathForItemAtPoint:touchPoint];
                if (!_originalIndexPath) {
                    return;
                }
                _snapshotView = [selectedItemCell.container snapshotViewAfterScreenUpdates:YES];
                _snapshotView.center = [recognizer locationInView:self.collectionView];
                [self.collectionView addSubview:_snapshotView];
                selectedItemCell.hidden = YES;
                [UIView animateWithDuration:0.2 animations:^{
                    self->_snapshotView.transform = CGAffineTransformMakeScale(1.03, 1.03);
                    self->_snapshotView.alpha = 0.98;
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            _snapshotView.center = [recognizer locationInView:self.collectionView];
            
            if (_moveIndexPath.section == 0) {
                if (_moveIndexPath && ![_moveIndexPath isEqual:_originalIndexPath] && _moveIndexPath.section == _originalIndexPath.section) {
                    WKHomeWorkGroup *homeGroup = self.itemGroups[0];
                    NSMutableArray *array = homeGroup.items;
                    NSInteger fromIndex = _originalIndexPath.item;
                    NSInteger toIndex = _moveIndexPath.item;
                    if (fromIndex < toIndex) {
                        for (NSInteger i = fromIndex; i < toIndex; i++) {
                            [array exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                        }
                    }else{
                        for (NSInteger i = fromIndex; i > toIndex; i--) {
                            [array exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
                        }
                    }
                    [self.collectionView moveItemAtIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
                    _originalIndexPath = _moveIndexPath;
                }
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            WKFunsItemCell *cell = (WKFunsItemCell *)[self.collectionView cellForItemAtIndexPath:_originalIndexPath];
            cell.hidden = NO;
            [_snapshotView removeFromSuperview];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - WKFunsItemCellDelegate(点击右上角按钮)
- (void)rightUpperButtonDidTappedWithItemCell:(WKFunsItemCell *)selectedItemCell {
    WKHomeWork *homeWork = selectedItemCell.homeWork;
    if (homeWork.hystatus == HYStatusMinusSign) {
        WKHomeWorkGroup *homeGroup = self.itemGroups[0];
        [(NSMutableArray *)homeGroup.items removeObject:homeWork];
        for (WKHomeWork *item in self.allItemModel) {
            if ([homeWork.gridTitle isEqualToString:item.gridTitle]) {
                item.hystatus = HYStatusPlusSign;
                break;
            }
        }
         UIView *snapshotView = [selectedItemCell snapshotViewAfterScreenUpdates:YES];
         snapshotView.frame = [selectedItemCell convertRect:selectedItemCell.bounds toView:self.view];
         [self.view addSubview:snapshotView];
         selectedItemCell.hidden = YES;
         [UIView animateWithDuration:0.4 animations:^{
            snapshotView.transform = CGAffineTransformMakeScale(0.1, 0.1);
         } completion:^(BOOL finished) {
            [snapshotView removeFromSuperview];
            selectedItemCell.hidden = NO;
            [self.collectionView reloadData];
         }];
    } else if (homeWork.hystatus == HYStatusPlusSign) {
        homeWork.hystatus = HYStatusCheck;
        WKHomeWorkGroup *homeGroup = self.itemGroups[0];
        WKHomeWork *homeItem = [[WKHomeWork alloc] init];
        homeItem.iconImage = homeWork.iconImage;
        homeItem.gridTitle = homeWork.gridTitle;
        homeItem.pageType = homeWork.pageType;
        homeItem.prefix = homeWork.prefix;
        homeItem.destVcClass = homeWork.destVcClass;
        homeItem.load = homeWork.load;
        homeItem.hystatus = HYStatusMinusSign;
        [homeGroup.items addObject:homeItem];
        
        UIView *snapshotView = [selectedItemCell snapshotViewAfterScreenUpdates:YES];
        snapshotView.frame = [selectedItemCell convertRect:selectedItemCell.bounds toView:self.view];
        [self.view addSubview:snapshotView];
        
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        
        WKFunsItemCell *lastCell = (WKFunsItemCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:homeGroup.items.count - 1 inSection:0]];
        lastCell.hidden = YES;
        CGRect targetFrame = [lastCell convertRect:lastCell.bounds toView:self.view];
        
        [UIView animateWithDuration:0.4 animations:^{
            snapshotView.frame = targetFrame;
        } completion:^(BOOL finished) {
            [snapshotView removeFromSuperview];
            lastCell.hidden = NO;
        }];
    }
}

#pragma mark - 屏幕横竖屏设置
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

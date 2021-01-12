//
//  WKFunsViewController.m
//  HYWork
//
//  Created by information on 2021/1/12.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKFunsViewController.h"

// view
#import "WKFunsItemCell.h"
#import "WKFunsItemHeaderView.h"

// model
#import "WKFunsItemGroup.h"

static NSString *cellID = @"WKFunsItemCell";
static NSString *headerViewID = @"WKFunsItemHeaderView";

@interface WKFunsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

/** 编辑状态 */
@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, strong) NSArray *itemGroups;

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
}

#pragma mark - 设置导航栏
- (void)setupNav {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = PFR15Font;
    [button setTitle:@"管理" forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateSelected];
    [button sizeToFit];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(managerAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *managerItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = managerItem;
}

- (void)managerAction:(UIButton *)managerButton {
    managerButton.selected = !managerButton.selected;
    self.isEditing = managerButton.selected;
    [self.collectionView reloadData];
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
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[WKFunsItemCell class] forCellWithReuseIdentifier:cellID];
    [_collectionView registerClass:[WKFunsItemHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [_collectionView addGestureRecognizer:longPress];

}

- (NSArray *)itemGroups {
    if (!_itemGroups) {
        
        NSArray *datas = @[
                           @{
                               @"type" : @"首页快捷入口",
                               @"items" :[NSMutableArray array]
                               },
                           @{
                               @"type" : @"我的",
                               @"items" : @[@{@"imageName" : @"我的订阅",@"itemTitle" : @"我的订阅"},
                                            @{@"imageName" : @"球爆",@"itemTitle" : @"球爆"},]
                               },
                           @{
                               @"type" : @"基础服务",
                               @"items" : @[@{@"imageName" : @"名人名单",@"itemTitle" : @"名人名单"},
                                            @{@"imageName" : @"竞彩足球",@"itemTitle" : @"竞彩足球"},
                                            @{@"imageName" : @"竞彩篮球",@"itemTitle" : @"竞彩篮球"},
                                            @{@"imageName" : @"足彩",@"itemTitle" : @"足彩"},]
                               },
                           @{
                               @"type" : @"发现新鲜事",
                               @"items" : @[@{@"imageName" : @"爆单",@"itemTitle" : @"爆单"},
                                            @{@"imageName" : @"专业分析",@"itemTitle" : @"专业分析"},
                                            @{@"imageName" : @"最新话题",@"itemTitle" : @"最新话题"},
                                            @{@"imageName" : @"热门话题",@"itemTitle" : @"热门话题"},]
                             },
                           @{
                               @"type":@"新闻资讯",
                               @"items" : @[@{@"imageName" : @"热点资讯",@"itemTitle" : @"热点资讯"},
                                            @{@"imageName" : @"我不是头条",@"itemTitle" : @"我不是头条"},
                                            @{@"imageName" : @"名人专访",@"itemTitle" : @"名人专访"},
                                            @{@"imageName" : @"焦点赛事",@"itemTitle" : @"焦点赛事"},
                                            @{@"imageName" : @"活动专栏",@"itemTitle" : @"活动专栏"},]
                               },
                            ];
        
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:datas.count];
        NSMutableArray *allItemModels = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in datas) {
            WKFunsItemGroup *group = [[WKFunsItemGroup alloc] initWithDict:dict];
            if ([group.type isEqualToString:@"首页快捷入口"]) {
                for (WKFunsItem *item in group.items) {
                    item.status = StatusMinusSign;
                }
            }else {
                [allItemModels addObjectsFromArray:group.items];
            }
            [array addObject:group];
        }
        _itemGroups = [array copy];
        _allItemModel = [allItemModels copy];
    }
    
    return _itemGroups;
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.itemGroups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    WKFunsItemGroup *group = self.itemGroups[section];
    return group.items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WKFunsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
//    cell.backgroundColor = kRandomColor;
    WKFunsItemGroup *group = self.itemGroups[indexPath.section];
    WKFunsItem *itemModel = group.items[indexPath.row];
    if (indexPath.section != 0) {
        BOOL isAdded = NO;
        WKFunsItemGroup *homeGroup = self.itemGroups[0];
        for (WKFunsItem *homeItemModel in homeGroup.items) {
            
            if ([homeItemModel.itemTitle isEqualToString:itemModel.itemTitle]) {
                isAdded = YES;
                break;
            }
        }
        
        if (isAdded) {
            itemModel.status = StatusCheck;
        }else {
            itemModel.status = StatusPlusSign;
        }
    }
    cell.isEditing = _isEditing;
    cell.funsItem = group.items[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        WKFunsItemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        
        WKFunsItemGroup *group = self.itemGroups[indexPath.section];
        headerView.title = group.type;

        return headerView;
    }else {
        return nil;
    }
}

@end

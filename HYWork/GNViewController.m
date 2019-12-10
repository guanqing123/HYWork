//
//  GNViewController.m
//  HYWork
//
//  Created by information on 16/3/21.
//  Copyright © 2016年 hongyan. All rights reserved.
//
#define GNContentCell @"GNContentCell"
#define GNHeader @"GNHeader"

#define DEFAULT_SERVERUEL @"http://www.sge.cn:9080/WebReport/ReportServer"
#define DEFAULT_SERVERNAME @"决策分析"

#import <FineSoft/IFIntegrationUtils.h>
#import <FineSoft/IFFrameDirectoryViewController.h>
#import <FineSoft/IFEntryNode.h>
#import <FineSoft/IFEntryViewController.h>
#import <FineSoft/IFOEMUtils.h>
#import <FineSoft/IFFrameDirectoryRootViewController.h>
#import <FineSoft/IFFrameAppSettingViewController.h>

#import "FRCustomDirectoryViewController.h"

#import "GNViewController.h"
#import "XLPlainFlowLayout.h"
#import "ReusableView.h"
#import "Group.h"
#import "GNCell.h"
#import "LoadViewController.h"
#import "WKJCFXViewController.h"
#import "YYAnimationIndicator.h"

#define WKVersionFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"version.plist"]

@interface GNViewController () {
    IFFrameDirectoryViewController *directoryVC;
    YYAnimationIndicator *indicator;
}

@property (nonatomic, strong)  NSMutableArray *reportsArray;

@property (strong, nonatomic)  NSArray *gns;

@property (nonatomic, strong)  LoadViewController *loadViewController;
@end

@implementation GNViewController

//static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    // 流水布局
    //UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
    // 每个cell的尺寸
    
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 4 * 20) / 4, ([UIScreen mainScreen].bounds.size.width - 4 * 20) / 4);
//    CGSizeMake(([UIScreen mainScreen].bounds.size.width-20) /2, ([UIScreen mainScreen].bounds.size.height-140) /3);
    // 设置cell之间的水平间距
    layout.minimumInteritemSpacing = 0;
    // 设置cell之间的垂直间距
    layout.minimumLineSpacing = 10;
    // 设置四周的内边距
    layout.sectionInset = UIEdgeInsetsMake(layout.minimumLineSpacing, 10, 10, 10);
    
//    if (self = [super initWithCollectionViewLayout:layout]) {} return self;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[GNCell class] forCellWithReuseIdentifier:GNContentCell];
    [self.collectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GNHeader];
    
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    indicator = [[YYAnimationIndicator alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *loadingItem = [[UIBarButtonItem alloc]initWithCustomView:indicator];
    self.navigationItem.leftBarButtonItem = loadingItem;
}

- (NSArray *)gns {
    if (_gns == nil) {
        // JSON文件的路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gns" ofType:@"json"];
        
        // 加载JSON文件
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        // 将JSON数据转为NSArray或者NSDictionary
        NSArray *dictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        // 将字典转成模型
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            Group *group = [Group groupWithDict:dict];
            [itemArray addObject:group];
        }
        _gns = itemArray;
    }
    return _gns;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.gns.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Group *group = self.gns[section];
    return  group.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //获得cell
    GNCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GNContentCell forIndexPath:indexPath];
    Group *group = self.gns[indexPath.section];
    Item *item = group.items[indexPath.item];
    cell.item = item;
    
    return cell;
}

#pragma mark - View for sectionHeader
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    Group *group = self.gns[indexPath.section];
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        ReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GNHeader forIndexPath:indexPath];
        [header initText:group.header r:group.r g:group.g b:group.b];
        if (indexPath.section == 2) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat margin = 5;
            CGFloat buttonW = 20;
            CGFloat buttonH = buttonW;
            CGFloat buttonX = SCREEN_WIDTH - buttonW - margin;
            button.frame = CGRectMake(buttonX, margin, buttonW, buttonH);
            [button setImage:[UIImage imageNamed:@"planDelete"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clearCache) forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:button];
        }
        reusableview = header;
    }
    return reusableview;
}

- (void)clearCache {
    [MBProgressHUD showMessage:@"缓存清除中..." toView:self.view];
    NSDictionary *localDict = [NSDictionary dictionaryWithContentsOfFile:WKVersionFile];
    if (localDict==nil) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"清除成功"];
    }else{
        [localDict setValue:@(0) forKey:@"cpkj"];
        BOOL flag = [localDict writeToFile:WKVersionFile atomically:YES];
        [MBProgressHUD hideHUDForView:self.view];
        if (flag) {
            [MBProgressHUD showSuccess:@"清除成功"];
        }else{
            [MBProgressHUD showError:@"清除失败"];
        }
    }
}

#pragma mark - height for sectionHeader
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 35);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Group  *group = self.gns[indexPath.section];
    Item *item = group.items[indexPath.item];
    
    if (_loadViewController == nil) {
        _loadViewController = [LoadViewController shareInstance];
    }
    
    UIViewController *vc = nil;
    if ([item.load intValue]) {
        if (_loadViewController.isLoaded) {
            if ([item.destVcClass isEqualToString:@"AppDelegate4OEM"]) {
                [self invokeFRRootVc:item];
                return;
            }else{
                vc = [[NSClassFromString(item.destVcClass) alloc] init];
                vc.title = item.title;
            }
        }else {
            vc = _loadViewController;
        }
    }else{
        vc = [[NSClassFromString(item.destVcClass) alloc] init];
    }
    
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - FineReport
- (void)invokeFRRootVc:(Item *)item {
    
    NSString *url = _loadViewController.emp.frdz;
    NSString *username = _loadViewController.emp.ygbm;
    NSString *password = _loadViewController.emp.oamm;
    
    if (@available(iOS 13.0, *)) {
        WKJCFXViewController *jcfxVc = [[WKJCFXViewController alloc] initWithUserName:username password:password];
        jcfxVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jcfxVc animated:YES];
    } else {
    
        [indicator startAnimation];  //开始转动
        
        [IFOEMUtils setShowMainMenuLeftBackButton:YES];
        
        //登录服务器
        [IFIntegrationUtils logInto:item.title serverUrl:url withUsername:username andPassword:password success:^(id content){
            //登录成功，加载目录树
            [IFIntegrationUtils loadReportTree:^(NSMutableArray *reportsArray) {
                [indicator stopAnimation];
                //加载成功，展示目录树
                directoryVC = [[IFFrameDirectoryViewController alloc] initWithReportsArray:reportsArray];
                [self.navigationController presentViewController:directoryVC animated:YES completion:nil];
            } failure:^(NSString *msg) {
                [indicator stopAnimation];
            } isObj:NO];
        } failure:^(NSString *msg) {
            [indicator stopAnimation];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
    }
}

#pragma mark -屏幕横竖屏设置
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

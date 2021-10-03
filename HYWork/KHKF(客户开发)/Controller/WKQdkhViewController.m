//
//  WKQdkhViewController.m
//  HYWork
//
//  Created by information on 2018/11/20.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#define QdkhCellID @"QdkhCell"

#import "WKQdkhViewController.h"
#import "RjhBpcSearchViewController.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "WKQdkhHeaderView.h"
#import "WKQdkh2HeaderView.h"
#import "KhkfManager.h"
#import "MBProgressHUD+MJ.h"
#import "LoadViewController.h"

#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZImagePickerController.h"
#import "YBImageBrowser.h"

#import "RXAddressiOS9.h"
#import "RXAddressiOS10.h"
#define SYSTEMVERSION   [UIDevice currentDevice].systemVersion
#define iOS9OrLater ([SYSTEMVERSION floatValue] >= 9.0)

@interface WKQdkhViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WKQdkhHeaderViewDelegate,RjhBpcSearchViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,YBImageBrowserDataSource> {
    CGFloat _itemWH;
    CGFloat _margin;
    
    RXAddressiOS9 * _objct9;
    RXAddressiOS10 * _objct10;
}

@property (nonatomic, strong) LxGridViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong)  WKQdkh *qdkh;

@property (nonatomic, strong)  UIImagePickerController *imagePickerVc;

@property (nonatomic, strong)  NSMutableArray *outSelectedPhotos;
@property (nonatomic, strong)  NSMutableArray *inSelectedPhotos;
@property (nonatomic, strong)  NSMutableArray *showPhotos;

@end

@implementation WKQdkhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.设置导航栏
    [self setupNavBar];
    
    // 2.初始化CollectionView
    [self setupCollectionView];
    
    // 3.设置 readAddress
    [self setupReadAddress];
}

// 4.照片 数组
- (NSMutableArray *)outSelectedPhotos {
    if (_outSelectedPhotos == nil) {
        _outSelectedPhotos = [NSMutableArray array];
    }
    return _outSelectedPhotos;
}

- (NSMutableArray *)inSelectedPhotos {
    if (_inSelectedPhotos == nil) {
        _inSelectedPhotos = [NSMutableArray array];
    }
    return _inSelectedPhotos;
}

- (void)setBzxh:(NSString *)bzxh {
    _bzxh = bzxh;
    if ([bzxh length] > 0) {
        WKQdkhParam *qdkh = [WKQdkhParam param:getQdkh];
        qdkh.baxh = bzxh;
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        [KhkfManager getQdkhBean:qdkh success:^(WKQdkh *qdkh) {
            [MBProgressHUD hideHUDForView:self.view];
            if (qdkh == nil) {
                [MBProgressHUD showError:@"加载失败" toView:self.view];
            }else{
                self->_qdkh = qdkh;
                NSString *fj1Path = [NSString stringWithFormat:@"http://218.75.78.166:9106/ftp/download?ftpPath=wenj/fxs&fileName=%@",qdkh.fj1];
                NSData *fj1Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fj1Path]];
                UIImage *fj1Image = [UIImage imageWithData:fj1Data];
                
                NSString *fj2Path = [NSString stringWithFormat:@"http://218.75.78.166:9106/ftp/download?ftpPath=wenj/fxs&fileName=%@",qdkh.fj2];
                NSData *fj2Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fj2Path]];
                UIImage *fj2Image = [UIImage imageWithData:fj2Data];
                
                [self.outSelectedPhotos addObject:fj1Image];
                [self.inSelectedPhotos addObject:fj2Image];
                [self.collectionView reloadData];
            }
        } fail:^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"网络异常" toView:self.view];
        }];
        
    }else{
        _qdkh = [[WKQdkh alloc] init];
        _qdkh.xh = @"0";
        _qdkh.ywy = [LoadViewController shareInstance].emp.ygbm;
    }
}

#pragma mark - 设置导航栏
- (void)setupNavBar {
    self.title = @"渠道客户(分销商)新增";
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save"] style:UIBarButtonItemStyleDone target:self action:@selector(save)];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save{
    if ([_qdkh.ty17 length]<1 || [_qdkh.khmc length]<1) {
        [MBProgressHUD showError:@"上级经销商不能为空!" toView:self.view];
        return;
    }
    if ([_qdkh.mc length] < 1) {
        [MBProgressHUD showError:@"客户名称不能为空!" toView:self.view];
        return;
    }
    if ([_qdkh.xl count] < 1) {
        [MBProgressHUD showError:@"合作产品系列不能为空!" toView:self.view];
        return;
    }
    if ([_qdkh.xsdlx length] < 1) {
        [MBProgressHUD showError:@"销售点类型不能为空!" toView:self.view];
        return;
    }
    if ([_qdkh.lxfs length] < 1) {
        [MBProgressHUD showError:@"电话不能为空!" toView:self.view];
        return;
    }
    if ([_qdkh.lxfs length] < 1) {
        [MBProgressHUD showError:@"联系人不能为空!" toView:self.view];
        return;
    }
    if ([_qdkh.ty20 length] < 1) {
        [MBProgressHUD showError:@"省市区不能为空!" toView:self.view];
        return;
    }
    if ([_qdkh.ty20 length] < 1) {
        [MBProgressHUD showError:@"详细地址不能为空!" toView:self.view];
        return;
    }
    if ([_outSelectedPhotos count] < 1) {
        [MBProgressHUD showError:@"门头照片不能为空!" toView:self.view];
        return;
    }
    if ([_inSelectedPhotos count] < 1) {
        [MBProgressHUD showError:@"店内照片不能为空!" toView:self.view];
        return;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"wenj/fxs" forKey:@"ftpPath"];
    WEAKSELF
    WKQdkfParam *qdkfParam = [WKQdkfParam param:saveQdkh];
    qdkfParam.qdkh = self.qdkh;
    [MBProgressHUD showMessage:@"保存中..." toView:self.view];
    [KhkfManager savePhoto:dict imageArray:self.outSelectedPhotos success:^(WKPhotoResult *photoResult) {
        if (photoResult == nil) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showError:@"保存失败" toView:weakSelf.view];
        }else{
            weakSelf.qdkh.fj1 = photoResult.saveName;
            [KhkfManager savePhoto:dict imageArray:self->_inSelectedPhotos success:^(WKPhotoResult *photoResult) {
                
                if (photoResult == nil) {
                    [MBProgressHUD hideHUDForView:weakSelf.view];
                    [MBProgressHUD showError:@"保存失败" toView:weakSelf.view];
                }else{
                    weakSelf.qdkh.fj2 = photoResult.saveName;
                    
                    [KhkfManager saveQdkf:qdkfParam success:^(BOOL flag) {
                        [MBProgressHUD hideHUDForView:weakSelf.view];
                        if (flag) {
                            [MBProgressHUD showSuccess:@"保存成功" toView:weakSelf.view];
                            if ([self.delegate respondsToSelector:@selector(qdkhViewControllerFinishSave:)]) {
                                [self.delegate qdkhViewControllerFinishSave:self];
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [MBProgressHUD showError:@"保存失败" toView:weakSelf.view];
                        }
                    } fail:^{
                        [MBProgressHUD hideHUDForView:weakSelf.view];
                        [MBProgressHUD showError:@"保存失败" toView:weakSelf.view];
                    }];
                }
                
            } failure:^{
                [MBProgressHUD hideHUDForView:weakSelf.view];
                [MBProgressHUD showError:@"保存失败" toView:weakSelf.view];
            }];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showError:@"保存失败" toView:weakSelf.view];
    }];
    
}

#pragma mark - 初始化CollectionView
- (void)setupCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 15;
    NSInteger cols = 3;
    // - 2 * _margin 减去左右内边距; - (cols - 1) * _margin 减去Item之间的 minimumInteritemSpacing
    _itemWH = (self.view.dc_width - 2 * _margin - (cols - 1) * _margin) / cols;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.sectionInset = UIEdgeInsetsMake(_margin, _margin, _margin, _margin);
    _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = GQColor(244, 244, 244);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"WKQdkhHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"qdkhHeaderView"];
    [_collectionView registerNib:[UINib nibWithNibName:@"WKQdkh2HeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"qdkh2HeaderView"];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark - 初始化通讯录
- (void)setupReadAddress {
    __weak typeof(self)weakSelf = self;
    
    _objct10 = [[RXAddressiOS10 alloc] init];
    _objct10.complete = ^(BOOL status, NSString * phoneNum, NSString * nameString) {
        if(status) {
            weakSelf.qdkh.lxfs = phoneNum;
        }
        weakSelf.qdkh.lxr = nameString;
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    };
    _objct9 = [[RXAddressiOS9 alloc] init];
    _objct9.complete = ^(BOOL status, NSString * phoneNum, NSString * nameString) {
        if(status) {
            weakSelf.qdkh.lxfs = phoneNum;
        }
        weakSelf.qdkh.lxr = nameString;
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    };
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.outSelectedPhotos.count + 1;
    }else if (section == 1){
        return self.inSelectedPhotos.count + 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.section == 0) {
        if (indexPath.row == self.outSelectedPhotos.count) {
            cell.imageView.image = [UIImage imageNamed:@"addImage"];
            cell.deleteBtn.hidden = YES;
            cell.gifLable.hidden = YES;
        }else{
            cell.imageView.image = self.outSelectedPhotos[indexPath.row];
            cell.deleteBtn.hidden = NO;
            cell.gifLable.hidden = YES;
        }
    } else if (indexPath.section == 1){
        if (indexPath.row == self.inSelectedPhotos.count) {
            cell.imageView.image = [UIImage imageNamed:@"addImage"];
            cell.deleteBtn.hidden = YES;
            cell.gifLable.hidden = YES;
        }else{
            cell.imageView.image = self.inSelectedPhotos[indexPath.row];
            cell.deleteBtn.hidden = NO;
            cell.gifLable.hidden = YES;
        }
    }
    cell.deleteBtn.tag = indexPath.section;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            WKQdkhHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"qdkhHeaderView" forIndexPath:indexPath];
            headerView.delegate = self;
            headerView.qdkh = self.qdkh;
            reusableView = headerView;
        }
        if (indexPath.section == 1) {
            WKQdkh2HeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"qdkh2HeaderView" forIndexPath:indexPath];
            reusableView = headerView;
        }
    }
    
    return reusableView;
}

#pragma mark 删除图片
- (void)deleteBtnClick:(UIButton *)button {
    switch (button.tag) {
        case 0 : {
            [self.outSelectedPhotos removeLastObject];
            __weak typeof(self) weakSelf = self;
            [self.collectionView performBatchUpdates:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            } completion:^(BOOL finished) {
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }];
            break;
        }
        case 1 : {
            [self.inSelectedPhotos removeLastObject];
            __weak typeof(self) weakSelf = self;
            [self.collectionView performBatchUpdates:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
                [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            } completion:^(BOOL finished) {
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - LxGridViewDataSource
/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.item < self.outSelectedPhotos.count;
    }else if (indexPath.section == 1) {
        return indexPath.item < self.inSelectedPhotos.count;
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.section != destinationIndexPath.section) {
        return NO;
    }
    if (sourceIndexPath.section == 0) {
        return (sourceIndexPath.item < self.outSelectedPhotos.count && destinationIndexPath.item < self.outSelectedPhotos.count);
    }else if (sourceIndexPath.section == 1){
        return (sourceIndexPath.item < self.inSelectedPhotos.count && destinationIndexPath.item < self.inSelectedPhotos.count);
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.section != destinationIndexPath.section) {
        return;
    }
    if (sourceIndexPath.section == 0) {
        UIImage *image = self.outSelectedPhotos[sourceIndexPath.item];
        [self.outSelectedPhotos removeObjectAtIndex:sourceIndexPath.item];
        [self.outSelectedPhotos insertObject:image atIndex:destinationIndexPath.item];
        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:sourceIndexPath.section]];
    }else if (sourceIndexPath.section == 1) {
        UIImage *image = self.inSelectedPhotos[sourceIndexPath.item];
        [self.inSelectedPhotos removeObjectAtIndex:sourceIndexPath.item];
        [self.inSelectedPhotos insertObject:image atIndex:destinationIndexPath.item];
        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:sourceIndexPath.section]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 660);
    }
    if (section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 30);
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // out
        
        if (indexPath.row == self.outSelectedPhotos.count) {
            if (self.outSelectedPhotos.count > 0) {
                return;
            }
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            // 拍照
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto:indexPath.section];
            }];
            [alertVc addAction:takePhotoAction];
            // 相册
            UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushTZImagePickerController:indexPath.section];
            }];
            [alertVc addAction:imagePickerAction];
            // 取消
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:cancelAction];
            UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            if (popover) {
                popover.sourceView = cell;
                popover.sourceRect = cell.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            }
            [self presentViewController:alertVc animated:YES completion:nil];
        }else{
            self.showPhotos = self.outSelectedPhotos;
            YBImageBrowser *browser = [YBImageBrowser new];
            browser.dataSource = self;
            [browser show];
        }
        
    }else if (indexPath.section == 1){ // in
        
        if (indexPath.row == self.inSelectedPhotos.count) {
            
            if (self.inSelectedPhotos.count > 0) {
                return;
            }
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            // 拍照
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto:indexPath.section];
            }];
            [alertVc addAction:takePhotoAction];
            // 相册
            UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushTZImagePickerController:indexPath.section];
            }];
            [alertVc addAction:imagePickerAction];
            // 取消
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:cancelAction];
            UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            if (popover) {
                popover.sourceView = cell;
                popover.sourceRect = cell.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            }
            [self presentViewController:alertVc animated:YES completion:nil];
            
        }else{
            self.showPhotos = self.inSelectedPhotos;
            YBImageBrowser *browser = [YBImageBrowser new];
            browser.dataSource = self;
            [browser show];
        }
    }
}

#pragma mark - <YBImageBrowserDataSource>
- (NSInteger)yb_numberOfCellsInImageBrowser:(YBImageBrowser *)imageBrowser {
    return self.showPhotos.count;
}

- (id<YBIBDataProtocol>)yb_imageBrowser:(YBImageBrowser *)imageBrowser dataForCellAtIndex:(NSInteger)index {
    UIImage *image = (UIImage *)self.showPhotos[index];
    YBIBImageData *data = [YBIBImageData new];
    data.image = ^UIImage * _Nullable{
        return image;
    };
    return data;
}

#pragma mark - 照片相关
#pragma mark 拍照
- (void)takePhoto:(NSInteger)section {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相册权限 做一个友好的提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto:section];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    }else if ([PHPhotoLibrary authorizationStatus] == 2){ // 已被拒绝,没有相册权限,将无法保存拍的照片
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }else if ([PHPhotoLibrary authorizationStatus] == 0){ // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto:section];
        }];
    }else{
        [self pushImagePickerController:section];
    }
}

#pragma mark UIAlertViewDelegate 设置 相机/拍照 权限
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark 调用相机
- (void)pushImagePickerController:(NSInteger)section {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        self.imagePickerVc.view.tag = section;
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    }else{
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }else{
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(PHAsset *asset, NSError *error) {
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            }else{
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                [self refreshCollectionViewWithAsset:assetModel.asset image:image section:picker.view.tag];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAsset:(PHAsset *)asset image:(UIImage *)image section:(NSInteger)section {
    switch (section) {
        case 0 : {
            [self.outSelectedPhotos addObject:image];
            [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
            break;
        }
        case 1 : {
            [self.inSelectedPhotos addObject:image];
            [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
            break;
        }
        default:
            break;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark 相册
- (void)pushTZImagePickerController:(NSInteger)section {
    if (section == 0) { // out
        if ([self.outSelectedPhotos count] > 0) {
            return;
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.showSelectBtn = YES;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [self.outSelectedPhotos addObjectsFromArray:photos];
            [self->_collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    }else if (section == 1){
        if ([self.inSelectedPhotos count] > 0) {
            return;
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.showSelectBtn = YES;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [self.inSelectedPhotos addObjectsFromArray:photos];
            [self->_collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - WKQdkhHeaderViewDelegate
#pragma mark 客户代码点击
- (void)qdkhHeaderViewkhdmBtnDidClick:(WKQdkhHeaderView *)headerView {
    RjhBpcSearchViewController *bpcSearchVc = [[RjhBpcSearchViewController alloc] init];
    bpcSearchVc.delegate = self;
    [self.navigationController pushViewController:bpcSearchVc animated:YES];
}

#pragma mark 访问通讯录
- (void)qdkhHeaderViewVisitedAddressList:(WKQdkhHeaderView *)headerView {
    if (iOS9OrLater) {
        [_objct10 getAddress:self];
    }else{
        [_objct9 getAddress:self];
    }
}

#pragma mark - RjhBpcSearchViewControllerDelegate
- (void)rjhBpcSearchViewControllerDidSelectBpc:(RjhBpcSearchViewController *)bpcSearchVc {
    self.qdkh.ty17 = bpcSearchVc.bpc.khdm;
    self.qdkh.khmc = bpcSearchVc.bpc.khmc;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
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

//
//  RjhPhotoCollectionViewController.h
//  HYWork
//
//  Created by information on 2017/6/2.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhPlan.h"
@class RjhPhotoCollectionViewController;

@protocol RjhPhotoCollectionViewControllerDelegate <NSObject>
@optional
- (void)photoCollectionViewDidUploadPhotos:(RjhPhotoCollectionViewController *)photoCollectionVc;
@end

@interface RjhPhotoCollectionViewController : UICollectionViewController

@property (nonatomic, strong)  RjhPlan *plan;

/** 照片最大可选张数 */
@property (nonatomic, assign) int maxImagesCount;
/** 每行展示照片张数 */
@property (nonatomic, assign) int columnNumber;
/** 显示内部拍照按钮 */
@property (nonatomic, assign) BOOL cameraBtnSwitchValue;
/** 照片按修改时间升序排序 */
@property (nonatomic, assign) BOOL photoOrderSwitchValue;

@property (nonatomic, weak) id<RjhPhotoCollectionViewControllerDelegate>  delegate;

@end

//
//  RJHPhotoCollectionReusableView.h
//  HYWork
//
//  Created by information on 2017/6/2.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectPickerView.h"
@class RJHPhotoCollectionReusableView;

@protocol RJHPhotoCollectionReusableViewDelegate <NSObject>
@optional
- (void)photoCollectionReusableView:(RJHPhotoCollectionReusableView *)reusableView;
@end

@interface RJHPhotoCollectionReusableView : UICollectionReusableView

/** 照片最大可选张数 */
@property (nonatomic, assign) int maxImagesCount;
/** 每行展示照片张数 */
@property (nonatomic, assign) int columnNumber;
/** 显示内部拍照按钮 */
@property (nonatomic, assign) BOOL cameraBtnSwitchValue;
/** 照片按修改时间升序排序 */
@property (nonatomic, assign) BOOL photoOrderSwitchValue;

/** 照片展示张数的选择框 */
@property (nonatomic, strong)  SelectPickerView *selectPickerView;
/** 照片展示张数的选择框的数据来源 */
@property (nonatomic, strong)  NSMutableArray *columnNumberArray;

/** 代理 */
@property (nonatomic, weak) id<RJHPhotoCollectionReusableViewDelegate>  delegate;

@end

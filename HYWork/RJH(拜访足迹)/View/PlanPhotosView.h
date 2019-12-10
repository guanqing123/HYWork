//
//  PlanPhotosView.h
//  HYWork
//
//  Created by information on 2017/5/18.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanPhotosView : UIView
/**
 * 需要展示的图片(数组里面装的都是)
 */
@property (nonatomic, strong)  NSArray *photos;

/**
 *  根据图片的个数返回相册的最终尺寸
 */
+ (CGSize)photosViewSizeWithPhotosCount:(int)count;

@end

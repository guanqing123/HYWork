//
//  WKHomeWork.h
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
   pageTypeH5 = 0, // H5页面
   pageTypeNative = 1 // Native
} PageType;

@interface WKHomeWork : NSObject

/** 图片 */
@property (nonatomic, copy) NSString *iconImage;
/** 文字 */
@property (nonatomic, copy) NSString *gridTitle;
/** tag */
@property (nonatomic, copy) NSString *gridTag;
/** tag颜色 */
@property (nonatomic, copy) NSString *gridColor;
/** 页面类型 */
@property (nonatomic, assign) PageType pageType;
/** 页面前缀 */
@property (nonatomic, copy) NSString *prefix;
/** 目的类 */
@property (nonatomic, copy) NSString *destVcClass;
/** 登录 */
@property (nonatomic, assign) BOOL load;

@end

NS_ASSUME_NONNULL_END

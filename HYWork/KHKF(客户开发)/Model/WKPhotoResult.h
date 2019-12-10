//
//  WKPhotoResult.h
//  HYWork
//
//  Created by information on 2018/11/29.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKBaseResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKPhotoResult : WKBaseResult

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *ftpPath;

@property (nonatomic, copy) NSString *saveName;

@end

NS_ASSUME_NONNULL_END

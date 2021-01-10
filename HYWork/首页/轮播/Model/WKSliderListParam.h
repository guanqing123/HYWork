//
//  WKSliderListParam.h
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKSliderListParam : NSObject

@property (nonatomic, assign) NSInteger isTop;

@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END

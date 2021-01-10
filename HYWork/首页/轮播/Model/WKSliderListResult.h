//
//  WKSliderListResult.h
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKSliderList.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKSliderListResult : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong)  NSArray *data;

@property (nonatomic, copy) NSString *message;

@end

NS_ASSUME_NONNULL_END

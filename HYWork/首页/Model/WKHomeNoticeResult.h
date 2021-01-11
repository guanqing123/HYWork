//
//  WKHomeNoticeResult.h
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKHomeNotice.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKHomeNoticeResult : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong)  NSArray *data;

@property (nonatomic, copy) NSString *message;

@end

NS_ASSUME_NONNULL_END

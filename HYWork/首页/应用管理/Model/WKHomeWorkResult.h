//
//  WKHomeWorkResult.h
//  HYWork
//
//  Created by information on 2021/1/13.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKHomeWorkGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKHomeWorkResult : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray *data;


@end

NS_ASSUME_NONNULL_END

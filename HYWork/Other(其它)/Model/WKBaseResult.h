//
//  WKBaseResult.h
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKBaseResult : NSObject

@property (nonatomic, assign) BOOL error;
@property (nonatomic, copy) NSString *errorMsg;

+ (instancetype)result;

@end

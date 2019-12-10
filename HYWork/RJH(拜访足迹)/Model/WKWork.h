//
//  WKWork.h
//  HYWork
//
//  Created by information on 2018/11/12.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWork : NSObject

@property (nonatomic, assign) int jobType;

@property (nonatomic, copy) NSString *jobName;

@property (nonatomic, copy) NSString *jobRemark;

@end

NS_ASSUME_NONNULL_END

//
//  KqReqData.h
//  HYWork
//
//  Created by information on 16/4/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KqReqData : NSObject

/**
 *  城市编码
 */
@property (nonatomic, copy) NSString *citycode;

/**
 *  工号
 */
@property (nonatomic, copy) NSString *gh;

- (instancetype)initWithCityCode:(NSString *)citycode Gh:(NSString *)gh;

+ (instancetype)kqReqDataWithCityCode:(NSString *)citycode Gh:(NSString *)gh;

@end

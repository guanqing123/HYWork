//
//  Region.h
//  HYWork
//
//  Created by information on 16/4/1.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Region : NSObject

/**
 *  地址
 */
@property (nonatomic, copy) NSString *address;

/**
 *  城市编号
 */
@property (nonatomic, copy) NSString *citycode;

/**
 *  围栏ID
 */
@property (nonatomic, assign) int fenceid;

/**
 *  维度
 */
@property (nonatomic, assign) CLLocationDegrees latitude;

/**
 *  经度
 */
@property (nonatomic, assign) CLLocationDegrees longitude;

/**
 *  半径
 */
@property (nonatomic, assign) CGFloat radius;

/**
 * 唯一标示符
 */
//@property (nonatomic, copy) NSString *identifier;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)regionWithDict:(NSDictionary *)dict;

@end

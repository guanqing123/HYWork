//
//  KqRqData.h
//  HYWork
//
//  Created by information on 16/4/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KqRqData : NSObject

/**
 *  工号
 */
@property (nonatomic, copy) NSString *gh;

/**
 *  设备ID
 */
@property (nonatomic, copy) NSString *did;

/**
 *  是否需要绑定设备ID
 */
@property (nonatomic, assign, getter=isSign) NSString *sign;

- (instancetype)initWithGh:(NSString *)gh did:(NSString *)did sign:(NSString *)sign;

+ (instancetype)kqRqDataWidthGh:(NSString *)gh did:(NSString *)did sign:(NSString *)sign;

@end

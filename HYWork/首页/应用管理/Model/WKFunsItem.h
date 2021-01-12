//
//  WKFunsItem.h
//  HYWork
//
//  Created by information on 2021/1/13.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Status) {
    StatusMinusSign = 1, // 减号
    StatusPlusSign, // 加号
    StatusCheck, // 对勾
};

NS_ASSUME_NONNULL_BEGIN

@interface WKFunsItem : NSObject

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *itemTitle;

@property (nonatomic, assign) Status status;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

//
//  DES3EncryptUtil.h
//  DES3加解密工具
//  HYWork
//
//  Created by information on 2020/12/14.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DES3EncryptUtil : NSObject

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

@end

NS_ASSUME_NONNULL_END

//
//  SettingItem.h
//  HYWork
//
//  Created by information on 16/4/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SettingItemOption)();

@interface SettingItem : NSObject
/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  点击那个cell需要做什么事情
 */
@property (nonatomic, copy) SettingItemOption option;

/**
 是否需要登录
 */
@property (nonatomic, assign) BOOL loaded;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title loaded:(BOOL)loaded;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title;
@end

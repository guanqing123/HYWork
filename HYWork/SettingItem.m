//
//  SettingItem.m
//  HYWork
//
//  Created by information on 16/4/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "SettingItem.h"

@implementation SettingItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title loaded:(BOOL)loaded {
    SettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.loaded = loaded;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title {
    return [self itemWithIcon:icon title:title loaded:NO];
}

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithIcon:nil title:title];
}

@end

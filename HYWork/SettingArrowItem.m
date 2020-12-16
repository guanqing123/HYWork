//
//  SettingArrowItem.m
//  HYWork
//
//  Created by information on 16/4/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "SettingArrowItem.h"

@implementation SettingArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass loaded:(BOOL)loaded{
    SettingArrowItem *item = [self itemWithIcon:icon title:title loaded:loaded];
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass {
    return [self itemWithIcon:nil title:title destVcClass:destVcClass loaded:NO];
}

@end

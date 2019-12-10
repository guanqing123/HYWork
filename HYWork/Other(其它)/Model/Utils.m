//
//  Utils.m
//  HYWork
//
//  Created by information on 16/4/11.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "Utils.h"

@implementation Utils

static NSMutableDictionary *dict = nil;

+ (NSMutableDictionary *)getDict {
    if (dict == nil) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dict" ofType:@"plist"];
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }
    return dict;
}

@end

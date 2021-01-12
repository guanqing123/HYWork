//
//  WKHomeWork.m
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKHomeWork.h"

@implementation WKHomeWork

/**
 * 从文件中解析对象的时候调用
 */
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.iconImage = [decoder decodeObjectForKey:@"iconImage"];
        self.gridTitle = [decoder decodeObjectForKey:@"gridTitle"];
        self.gridTag = [decoder decodeObjectForKey:@"gridTag"];
        self.gridColor = [decoder decodeObjectForKey:@"gridColor"];
        self.pageType = [[decoder decodeObjectForKey:@"pageType"] intValue];
        self.prefix = [decoder decodeObjectForKey:@"prefix"];
        self.destVcClass = [decoder decodeObjectForKey:@"destVcClass"];
        self.load = [decoder decodeObjectForKey:@"load"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.iconImage forKey:@"iconImage"];
    [encoder encodeObject:self.gridTitle forKey:@"gridTitle"];
    [encoder encodeObject:self.gridTag forKey:@"gridTag"];
    [encoder encodeObject:self.gridColor forKey:@"gridColor"];
    [encoder encodeObject:@(self.pageType) forKey:@"pageType"];
    [encoder encodeObject:self.prefix forKey:@"prefix"];
    [encoder encodeObject:self.destVcClass forKey:@"destVcClass"];
    [encoder encodeObject:@(self.load) forKey:@"load"];
}

@end

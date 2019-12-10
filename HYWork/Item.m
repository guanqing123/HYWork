//
//  Item.m
//  HYWork
//
//  Created by information on 16/3/21.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "Item.h"

@implementation Item

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.image forKey:@"image"];
    [coder encodeObject:self.destVcClass forKey:@"destVcClass"];
    [coder encodeObject:self.order forKey:@"order"];
    [coder encodeObject:self.load forKey:@"load"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.destVcClass = [aDecoder decodeObjectForKey:@"destVcClass"];
        self.order = [aDecoder decodeObjectForKey:@"order"];
        self.load = [aDecoder decodeObjectForKey:@"load"];
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)itemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}


@end

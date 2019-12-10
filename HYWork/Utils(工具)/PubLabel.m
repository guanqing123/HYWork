//
//  PubLabel.m
//  HYWork
//
//  Created by information on 16/3/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "PubLabel.h"

@implementation PubLabel

- (instancetype)initWithFont:(UIFont *)font{
    if (self = [super init]) {
        self.font = font;
        self.textAlignment = NSTextAlignmentCenter;
        [self.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [self.layer setBorderWidth:0.5];
    }
    return self;
}

+ (instancetype)labelWithFont:(UIFont *)font {
    return [[self alloc] initWithFont:font];
}



@end


//
//  QuestionModel.m
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _question = [dict objectForKey:@"faq_question"];
        
        _solution = [dict objectForKey:@"faq_solution"];
        
        _reason = [dict objectForKey:@"faq_reason"];
        
        _isOpened = NO;
        
        _indexArry = [[NSMutableArray alloc] init];
        
        _solutionHight = 150;
        _reasonHight = 150;
    }
    return self;
}

+ (instancetype)questionWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

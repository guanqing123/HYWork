//
//  QuestionModel.h
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (strong, nonatomic) NSString *question;

@property (strong, nonatomic) NSString *solution;

@property (strong, nonatomic) NSString *reason;

@property (assign, nonatomic) BOOL isOpened;

@property (strong, nonatomic) NSMutableArray *questionArry;

@property (strong, nonatomic) NSMutableArray *listArry;

@property (strong, nonatomic) NSMutableArray *indexArry;

@property (assign, nonatomic) float reasonHight;

@property (assign, nonatomic) float solutionHight;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)questionWithDict:(NSDictionary *)dict;

@end

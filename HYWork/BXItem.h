//
//  BXItem.h
//  HYWork
//
//  Created by information on 16/5/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXItem : NSObject

@property (nonatomic, copy) NSString *currentnodeid;
@property (nonatomic, copy) NSString *currentnodetype;
@property (nonatomic, copy) NSString *lb;
@property (nonatomic, copy) NSString *newflag;
@property (nonatomic, copy) NSString *receivetime;
@property (nonatomic, copy) NSString *requestid;
@property (nonatomic, copy) NSString *requestlevel;
@property (nonatomic, copy) NSString *requestname;
@property (nonatomic, copy) NSString *workflowid;
@property (nonatomic, copy) NSString *workflowname;

+ (instancetype)bxItemWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end

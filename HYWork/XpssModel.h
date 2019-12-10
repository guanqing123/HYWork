//
//  XpssModel.h
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XpssModel : NSObject

@property (strong, nonatomic) NSString *imgUrl;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *content;

@property (assign, nonatomic) NSString *cymc;

@property (strong, nonatomic) NSString *cydm;

@property (strong, nonatomic) NSString *submit_date;

- (void)pickUp:(NSDictionary *)dict;

@end

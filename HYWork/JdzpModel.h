//
//  JdzpModel.h
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JdzpModel : NSObject

@property (strong, nonatomic) NSString *tiaomuId;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *imageUrl;

@property (strong, nonatomic) NSString *path;

@property (strong, nonatomic) NSString *create_date;

@property (strong, nonatomic) NSString *modify_date;

- (void)pickUp:(NSDictionary *)dict;

@end

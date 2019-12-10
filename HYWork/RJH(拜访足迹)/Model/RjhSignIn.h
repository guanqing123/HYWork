//
//  RjhSignIn.h
//  HYWork
//
//  Created by information on 2017/5/26.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RjhSignIn : NSObject

@property (nonatomic, copy) NSString *ygxm;

@property (nonatomic, assign) int count;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *signin;

@property (nonatomic, assign) BOOL canClick;

@property (nonatomic, assign) double signin_longitude;

@property (nonatomic, assign) double signin_latitude;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, assign) int type;

@property (nonatomic, assign) int logid;

@property (nonatomic, copy) NSString *action;
@end

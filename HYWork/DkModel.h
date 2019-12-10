//
//  DkModel.h
//  HYWork
//
//  Created by information on 16/3/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DkModel : NSObject

@property (copy, nonatomic) NSString *dkdw;
@property (copy, nonatomic) NSString *dkdd;
@property (copy, nonatomic) NSString *hzdd;
@property (copy, nonatomic) NSString *jzrq;
@property (copy, nonatomic) NSString *syhbbm;
@property (copy, nonatomic) NSString *zt;
@property (copy, nonatomic) NSString *ck;
@property (copy, nonatomic) NSString *je;
@property (copy, nonatomic) NSString *ms;
@property (copy, nonatomic) NSString *ywy;
@property (copy, nonatomic) NSString *bmmc;
@property (copy, nonatomic) NSString *khdm;
@property (copy, nonatomic) NSString *khmc;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end

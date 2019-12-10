//
//  WKBaseParam.h
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKBaseParam : NSObject

@property (nonatomic, copy) NSString *trdate;
@property (nonatomic, copy) NSString *trcode;
@property (nonatomic, copy) NSString *appseq;

+ (instancetype)param:(NSString *)trcode;

@end

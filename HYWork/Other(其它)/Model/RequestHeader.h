//
//  RequestHeader.h
//  HYWork
//
//  Created by information on 16/3/3.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHeader : NSObject
@property (nonatomic,copy) NSString *trdate;
@property (nonatomic,copy) NSString *trcode;
@property (nonatomic,copy) NSString *appseq;

- (instancetype)initWithTrcode:(NSString *)trcode;

- (instancetype)init;

@end

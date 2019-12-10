//
//  DtCellModel.h
//  HYWork
//
//  Created by information on 16/3/3.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DtCellModel : NSObject
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *readTimes;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *idStr;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)dtCellWithDict:(NSDictionary *)dict;
@end

//
//  WKHomeWorkGroup.h
//  HYWork
//
//  Created by information on 2021/1/13.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKHomeWork.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKHomeWorkGroup : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong)  NSMutableArray *items;

@end

NS_ASSUME_NONNULL_END

//
//  JdzpModel.m
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "JdzpModel.h"

@implementation JdzpModel

- (void)pickUp:(NSDictionary *)dict
{
    _tiaomuId = [dict objectForKey:@"id"];
    
    _title = [dict objectForKey:@"title"];
    
    _create_date = [dict objectForKey:@"create_date"];
    
    _modify_date = [dict objectForKey:@"modify_date"];
    
    if ([[dict objectForKey:@"path"] isKindOfClass:[NSNull class]])
    {
        _path = @"";
    }
    else
    {
        _path = [dict objectForKey:@"path"];
    }
    
    
    //    _imageUrl = [dict objectForKey:@"image"];
    
    if ([[dict objectForKey:@"image"] isKindOfClass:[NSNull class]])
    {
        _imageUrl = @"";
    }
    else
    {
        _imageUrl = [dict objectForKey:@"image"];
    }
    
    
    //    _imageUrl = [NSString stringWithFormat:@"http://218.75.78.166:9101%@",url];
}

@end

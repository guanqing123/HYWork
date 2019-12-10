//
//  XpssModel.m
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "XpssModel.h"

@implementation XpssModel

- (void)pickUp:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"img_url"] isKindOfClass:[NSNull class]])
    {
        _imgUrl = @"";
    }
    else
    {
        _imgUrl = [dict objectForKey:@"img_url"];
    }
    
    if ([[dict objectForKey:@"content"] isKindOfClass:[NSNull class]])
    {
        _content = @"";
    }
    else
    {
        _content = [dict objectForKey:@"content"];
    }
    
    
    _title = [dict objectForKey:@"title"];
    
    _cydm = [dict objectForKey:@"cydm"];
    
    _submit_date = [dict objectForKey:@"submit_date"];
}

@end

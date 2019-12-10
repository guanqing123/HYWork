//
//  FjViewController.h
//  HYWork
//
//  Created by information on 16/8/4.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface FjViewController : UIViewController

- (instancetype)initWithRequest:(NSURLRequest *)request Configuration:(WKWebViewConfiguration *)configuration;

@end

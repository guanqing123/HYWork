//
//  ImageDetailController.h
//  HYWork
//
//  Created by information on 16/4/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ImageDetailController : UIViewController

@property (nonatomic, weak) WKWebView  *wkWebView;

@property (nonatomic, copy) NSString *imgUrl;

- (instancetype)initWithImgUrl:(NSString *)imgUrl;

@end

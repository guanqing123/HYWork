//
//  WKLineFooterView.m
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKLineFooterView.h"

@implementation WKLineFooterView

+ (instancetype)footerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WKLineFooterView" owner:nil options:nil] lastObject];
}

@end

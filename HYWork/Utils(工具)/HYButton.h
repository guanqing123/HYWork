//
//  HYButton.h
//  HYWork
//
//  Created by information on 16/6/1.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYButton : UIButton

@property (nonatomic, copy) NSString *val;

@property (nonatomic, copy) NSString *dis;

+ (instancetype)customButton;

- (void)setVal:(NSString *)val andDis:(NSString *)dis;

@end

//
//  WKClassifyChooseView.h
//  HYWork
//
//  Created by information on 2018/6/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chooseFinishBlock)(void);

@interface WKClassifyChooseView : UIView

@property (nonatomic, copy) NSString *fl;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) chooseFinishBlock chooseFinish;

@end

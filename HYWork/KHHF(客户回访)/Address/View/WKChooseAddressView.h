//
//  WKChooseAddressView.h
//  HYWork
//
//  Created by information on 2018/5/16.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chooseFinishBlock)(void);

@interface WKChooseAddressView : UIView

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) chooseFinishBlock chooseFinish;
//@property (nonatomic, copy) void(^chooseFinish)(void);

@end

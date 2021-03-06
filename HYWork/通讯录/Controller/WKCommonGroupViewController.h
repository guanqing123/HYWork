//
//  WKCommonGroupViewController.h
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKCommonGroupViewController : UIViewController

@property (nonatomic, strong)  NSDictionary *commonDict;

- (void)requestCommonGroupDataWithBlock:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END

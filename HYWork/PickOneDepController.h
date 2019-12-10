//
//  PickOneDepController.h
//  HYWork
//
//  Created by information on 16/4/14.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickOneDepController : UIViewController
@property (nonatomic, strong)  NSDictionary *citiesDic;

- (void)requestOneDepDataWithBlock:(void(^)())block;
@end

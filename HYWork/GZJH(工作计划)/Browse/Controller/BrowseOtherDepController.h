//
//  BrowseOtherDepController.h
//  HYWork
//
//  Created by information on 16/5/31.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseOtherDepController : UIViewController

@property (nonatomic, strong)  NSDictionary *citiesDic;
@property (nonatomic, strong)  NSDictionary *tempDict;

- (void)refreshAllEmpsThroughSQLServerWithBlock:(void(^)())block;

@end

//
//  AddItemController.h
//  HYWork
//
//  Created by information on 16/3/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddItemController;

@protocol addItemControllerDelegate <NSObject>

- (void)addItemControllerDidFinishChoose:(AddItemController *)addItemController;

@end

@interface AddItemController : UIViewController

@property (nonatomic, weak) id<addItemControllerDelegate> delegate;

@end

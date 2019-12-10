//
//  FRCustomDirectory.h
//  FRDemo
//
//  Created by 魏阳露 on 15/6/23.
//  Copyright (c) 2015年 魏阳露. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 展示目录树/收藏夹的表格
 */
@interface FRCustomDirectoryViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

- (id) initWithNodes:(NSArray *) nodes;

@end

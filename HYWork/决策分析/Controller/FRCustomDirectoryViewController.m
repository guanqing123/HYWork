//
//  FRCustomDirectory.m
//  FRDemo
//
//  Created by 魏阳露 on 15/6/23.
//  Copyright (c) 2015年 魏阳露. All rights reserved.
//

#import "FRCustomDirectoryViewController.h"
#import <FineSoft/IFEntryNode.h>
#import <FineSoft/IFEntryViewController.h>

@implementation FRCustomDirectoryViewController {
    NSArray *entryNodes;
}

- (id) initWithNodes:(NSArray *) nodes {
    self = [self init];
    if(self) {
        entryNodes = nodes;
    }
    self.tableView.delegate = self;
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [entryNodes count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"entryCell"];
    NSInteger row = [indexPath row];
    if(cell == nil) {
        IFEntryNode *entryNode = [entryNodes objectAtIndex:row];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"entryCell"];
        cell.textLabel.text = entryNode.displayName;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    IFEntryNode *entryNode = [entryNodes objectAtIndex:row];
    IFEntryViewController *entryViewController = [[IFEntryViewController alloc] initWithEntry:entryNode];
    [self.navigationController pushViewController:entryViewController animated:YES];
}

@end

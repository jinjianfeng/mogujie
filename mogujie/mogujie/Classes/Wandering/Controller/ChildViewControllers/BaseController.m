//
//  BaseController.m
//  mogujie
//
//  Created by kevinlishuai on 15/12/27.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.tableView.bounces = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollEnabledDidChanged) name:@"UITableViewScrollEnabledChangedNotification" object:nil];
    
}


- (void)scrollEnabledDidChanged
{
    self.tableView.scrollEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"note" object:nil];
        scrollView.scrollEnabled = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@----%zd", self.class, indexPath.row];
    return cell;
}



@end

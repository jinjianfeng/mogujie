//
//  LSWanderingController.h
//  mogujie
//
//  Created by kevinlishuai on 15/11/13.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSBottomContentViewController;
@protocol LSBottomContentViewControllerDelegate <NSObject>

@optional
- (void)bottomContentViewController:(LSBottomContentViewController *)bottomVc currentTableViewContrller:(UITableViewController *)tableVc;

@end


@interface LSBottomContentViewController : UIViewController

/** 代理 */
@property (nonatomic, weak) id<LSBottomContentViewControllerDelegate> delegate;


@end

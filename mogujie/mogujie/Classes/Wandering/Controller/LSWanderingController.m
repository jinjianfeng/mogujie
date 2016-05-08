//
//  LSWanderingController.m
//  mogujie
//
//  Created by kevinlishuai on 15/12/26.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSWanderingController.h"
#import "LSBottomContentViewController.h"
#import "LSBannerViewController.h"

#import "UIView+frame.h"

@interface LSWanderingController () <UIScrollViewDelegate, LSBottomContentViewControllerDelegate>

@property (nonatomic, weak) UIScrollView * scrollView;

@property (nonatomic, weak) UIView * headerView;

@property (nonatomic, weak) UIView * bottomView;

@property (nonatomic, assign) CGFloat headerViewPoistion;

@property (nonatomic, assign) CGFloat tempFloat;


/** 图片轮播控制器 */
@property (nonatomic, weak) LSBannerViewController * bannerVC;


@end

@implementation LSWanderingController

- (void)viewDidLoad {
    [super viewDidLoad];

    /**
     *  初始化scrollview
     */
    [self setupScrollView];
    
    /**
     *  初始化头部视图
     */
    [self setupHeaderView];
    
    /**
     *  初始化底部视图
     */
    [self setupBottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wakeupScrollView) name:@"note" object:nil];

}

#pragma mark - 初始化底部视图
- (void)setupBottomView
{
    LSBottomContentViewController * bottomVc = [[LSBottomContentViewController alloc] init];
    bottomVc.delegate = self;
    bottomVc.view.frame = CGRectMake(0, navBarH + self.headerView.height , screenW, screenH - navBarH - self.headerView.height);
    [self.scrollView addSubview: bottomVc.view];
    [self addChildViewController:bottomVc];
    self.bottomView = bottomVc.view;
}

#pragma mark - 初始化图片轮播视图
- (void)setupBanner
{

    LSBannerViewController * bannerVC = [[LSBannerViewController alloc] init];
    bannerVC.view.frame = CGRectMake(0, 0, screenW, LSBannerH);
    [self.headerView addSubview:bannerVC.view];
    [self addChildViewController:bannerVC];
    self.bannerVC = bannerVC;
}

- (void)setupAD
{
    CGFloat adViewH = LSHeaderViewH - LSBannerH;
    
    UIScrollView * adView = [[UIScrollView alloc] init];
    adView.frame = CGRectMake(0, LSBannerH, screenW, adViewH);
    [self.headerView addSubview:adView];
    adView.showsVerticalScrollIndicator = NO;
    adView.showsHorizontalScrollIndicator = NO;
    adView.bounces = NO;
    
    CGFloat buttonH = adViewH - LSCommonMargin;
    CGFloat buttonW = buttonH;
    for (int i = 0; i < 9; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(LSCommonMargin * 0.5 + i * adViewH, LSCommonMargin * 0.5, buttonW, buttonH);
        button.backgroundColor = randomColor;
        [adView addSubview:button];
    }
    
    adView.contentSize = CGSizeMake(adViewH * 9, 0);
}

#pragma mark - 初始化头部视图
- (void)setupHeaderView
{
    UIView * headerView = [[UIView alloc] init];
    [self.scrollView addSubview:headerView];
    headerView.frame = CGRectMake(0, navBarH, screenW, LSHeaderViewH);
    headerView.backgroundColor = [UIColor blueColor];
    self.headerView = headerView;
    
    // 初始化图片轮播视图
    [self setupBanner];
    
    // 初始化广告视图
    [self setupAD];

    
}



#pragma mark - 初始化ScrollView
- (void)setupScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(0, screenH * 2);
    scrollView.bounces = NO;
    

//    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 300) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UITableViewScrollEnabledChangedNotification" object:nil];
        scrollView.contentOffset = CGPointMake(0, 300);
        scrollView.scrollEnabled = NO;
    } else if (scrollView.contentOffset.y >= LSBannerH) {
        [self.bannerVC stopTimer];
    } else if (scrollView.contentOffset.y > 0) {
        [self.bannerVC setupTimer];
    } else {
        
    }
}


#pragma mark - note
- (void)wakeupScrollView
{
    self.scrollView.scrollEnabled = YES;
}


- (void)bottomContentViewController:(LSBottomContentViewController *)bottomVc currentTableViewContrller:(UITableViewController *)tableVc
{
    if (self.scrollView.contentOffset.y < 300 && self.scrollView.contentOffset.y > 0) {
        tableVc.tableView.contentOffset = CGPointZero;
    }
}

@end

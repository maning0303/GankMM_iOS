//
//  BaseTabBarController.m
//  MN_酒店直达
//
//  Created by 马宁 on 16/5/3.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "GankViewController.h"
#import "OthersViewController.h"
#import "GirlsViewController.h"
#import "MNPicturesViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTabBar];
    
    [self addChildView];
    
}

/**
 *  设置自己的TabBar
 */
-(void)setTabBar
{
    //改变颜色
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0.950 alpha:0.8];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    
}

/**
 *  TabBar上面的按钮图片尺寸不能超过44
 */
-(void)addChildView
{
//    GirlsViewController *girlsVc = [[GirlsViewController alloc] init];
    MNPicturesViewController *girlsVc = [[MNPicturesViewController alloc] init];
    GankViewController *gankVc = [[GankViewController alloc] init];
    OthersViewController *othersVc = [[OthersViewController alloc] init];
    
    girlsVc.tabBarItem.title = @"美女";
    girlsVc.tabBarItem.image = [[UIImage imageNamed:@"tabBar_girls"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    girlsVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_girls_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    gankVc.tabBarItem.title = @"干货";
    gankVc.tabBarItem.image = [[UIImage imageNamed:@"tabBar_gank"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    gankVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_gank_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    othersVc.tabBarItem.title = @"其它";
    othersVc.tabBarItem.image = [[UIImage imageNamed:@"tabBar_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    othersVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_setting_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    BaseNavigationController *navVc1 = [[BaseNavigationController alloc] initWithRootViewController:girlsVc];
    BaseNavigationController *navVc2 = [[BaseNavigationController alloc] initWithRootViewController:gankVc];
    BaseNavigationController *navVc3 = [[BaseNavigationController alloc] initWithRootViewController:othersVc];
    
    [self addChildViewController:navVc1];
    [self addChildViewController:navVc2];
    [self addChildViewController:navVc3];
}


/**
 *  只会调用一次
 */
+(void)initialize
{
        //文字的属性
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
        attrs[NSForegroundColorAttributeName] = GankTabBarGrayColor;
    
        NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
        selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
        selectedAttrs[NSForegroundColorAttributeName] = GankMainColor;
    
        //通过appearance同一设置
        UITabBarItem *item = [UITabBarItem appearance];
        [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
        [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}


@end

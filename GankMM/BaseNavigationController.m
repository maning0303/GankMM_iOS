//
//  BaseNavigationController.m
//  MN_酒店直达
//
//  Created by 马宁 on 16/5/3.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

}

/**
 *  第一次使用这个类的时候调用一次
 */
+(void)initialize
{
    //设置背景图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:GankMainColor}];
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.childViewControllers.count > 0){
        //添加返回按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:GankMainColor forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.613 blue:0.515 alpha:1.000] forState:UIControlStateHighlighted];
        [backBtn setImage:[UIImage imageNamed:@"comment_back"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"comment_back"] forState:UIControlStateHighlighted];
        
        backBtn.size = CGSizeMake(100, 30);
        //按钮内容做对齐
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //按钮大小随内容
        //[backBtn sizeToFit];
        //设置内边距:返回键距离左边更近
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        //监听事件
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        
        //隐藏TabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
    NSLog(@"返回");
}


@end

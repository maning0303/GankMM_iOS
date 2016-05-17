//
//  AppDelegate.m
//  GankMM
//
//  Created by 马宁 on 16/5/9.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"


@interface AppDelegate ()

@property(nonatomic,strong)UIWindow *topWindow;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"开始执行：didFinishLaunchingWithOptions");
    
    //状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //创建主页面
    [self createWindow];
    
    //创建顶部Window(默认隐藏)
    [MNTopWindow show];
    
    [NSThread sleepForTimeInterval:2.0];//设置启动页面时间
    
    NSLog(@"结束执行：didFinishLaunchingWithOptions");
    
    return YES;
}


-(void)createWindow
{
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //导航控制器
    BaseTabBarController *tabBar = [[BaseTabBarController alloc] init];
    
    self.window.rootViewController = tabBar;
    
    //显示窗口
    [self.window makeKeyAndVisible];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

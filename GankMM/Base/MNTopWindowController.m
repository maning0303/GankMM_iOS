//
//  MNTopWindowController.m
//  GankMM
//
//  Created by 马宁 on 16/5/11.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNTopWindowController.h"

@interface MNTopWindowController ()

@end

@implementation MNTopWindowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark --单例
static id instance_;
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc]init];
    });
    return instance_;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [super allocWithZone:zone];
    });
    return instance_;
}



/**
 *  状态栏的显示和隐藏
 */
-(BOOL)prefersStatusBarHidden
{
    return _statusBarHidden;
}

/**
 *  状态栏的样式设置
 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return _statusBarStyle;
}

#pragma mark -- setter
-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    _statusBarStyle = statusBarStyle;
    //刷新状态
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)setStatusBarHidden:(BOOL)statusBarHidden
{
    _statusBarHidden = statusBarHidden;
    //刷新状态
    [self setNeedsStatusBarAppearanceUpdate];
}


@end

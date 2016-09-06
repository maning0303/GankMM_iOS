//
//  MNTopWindowController.h
//  GankMM
//
//  Created by 马宁 on 16/5/11.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNTopWindowController : UIViewController

/**
 *  获取实例
 */
+(instancetype)shareInstance;

/**
 *  保存状态栏的样式
 */
@property(nonatomic,assign)UIStatusBarStyle statusBarStyle;
/**
 *  保存状态栏的显示或隐藏
 */
@property(nonatomic,assign)BOOL statusBarHidden;

@end

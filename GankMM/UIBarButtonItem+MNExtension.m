//
//  UIBarButtonItem+MNExtension.m
//  MN_TabBar控制器
//
//  Created by 马宁 on 16/4/28.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "UIBarButtonItem+MNExtension.h"

@implementation UIBarButtonItem (MNExtension)


+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [tagBtn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    tagBtn.size = tagBtn.currentBackgroundImage.size;
    //设置点击事件
    [tagBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc]initWithCustomView:tagBtn];
}

@end

//
//  UIBarButtonItem+MNExtension.h
//  MN_TabBar控制器
//
//  Created by 马宁 on 16/4/28.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MNExtension)

+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end

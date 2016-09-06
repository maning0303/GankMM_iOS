//
//  UIView+MNExtension.h
//  MN_TabBar控制器
//
//  Created by 马宁 on 16/4/28.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MNExtension)


@property(nonatomic,assign)CGSize size;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;

/**
 *  在分类中声明@property，只会生成方法的声明，不会生成方法的实现和带有_的成员变量
 */

@end

//
//  MNTopWindow.m
//  GankMM
//
//  Created by 马宁 on 16/5/11.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNTopWindow.h"

@implementation MNTopWindow

//top窗体
static UIWindow *topWindow_;
static BOOL isHidden;

/**
 *  初始化
 */
+(void)initialize
{
    MNLog(@"TopWindow初始化");
    //延时处理
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        topWindow_ = [[UIWindow alloc] init];
        //最高级别
        topWindow_.windowLevel = UIWindowLevelAlert;
        //位置
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        topWindow_.frame = CGRectMake(statusBarFrame.size.width / 3, statusBarFrame.origin.x, statusBarFrame.size.width / 3, statusBarFrame.size.height);
        //设置根控制器
        topWindow_.rootViewController = [MNTopWindowController shareInstance];
        topWindow_.backgroundColor = [UIColor clearColor];
        //添加手势
        [topWindow_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topWindowClick)]];
    
        topWindow_.hidden = isHidden;
        
    });
}

/**
 *  显示Window
 */
+(void)show
{
    isHidden = NO;
    topWindow_.hidden = NO;
    MNLog(@"TopWindow----show---isHidden:%@",isHidden?@"YES":@"NO");
}

+(void)dismiss
{
    isHidden = YES;
    topWindow_.hidden = YES;
    MNLog(@"TopWindow----dismiss---isHidden:%@",isHidden?@"YES":@"NO");
}

/**
 *  点击事件
 */
+(void)topWindowClick
{
    MNLog(@"topWindowClick------isHidden:%@",isHidden?@"YES":@"NO");
    if(!isHidden){
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [self searchAllScrollViewsInView:keyWindow];
    }
}

/**
 * 找到参数view中所有的UIScrollView
 */
+(void)searchAllScrollViewsInView:(UIView *)view
{
    // 递归遍历所有的子控件
    for (UIScrollView *subview in view.subviews) {
        
        //转换坐标系，拿到正确的坐标,和窗口在同一个坐标系才能比较
        CGRect newFrame = [subview.superview convertRect:subview.frame toView:nil];
        CGRect windowBounds = [UIApplication sharedApplication].keyWindow.bounds;
        BOOL isShowingOnCurrentWindow = subview.window == [UIApplication sharedApplication].keyWindow && !subview.isHidden && subview.alpha>0.01 && CGRectIntersectsRect(newFrame, windowBounds);
        
        // 判断ScrollView控件类型,并且在当前展示的窗口上
        if ([subview isKindOfClass:[UIScrollView class]] && isShowingOnCurrentWindow){
            CGPoint offset = subview.contentOffset;
            offset.y = -subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        
        //继续查找
        [self searchAllScrollViewsInView:subview];
    }
    
}


@end

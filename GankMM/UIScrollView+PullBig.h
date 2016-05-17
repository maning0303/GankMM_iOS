//
//  UIScrollView+PullBig.h
//  pullWithBig
//
//  Created by 神说有光 on 15/4/30.
//  Copyright (c) 2015年 Our Dream. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIScrollView (PullBig)
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIView *headerView;
-(void)setBigView:(UIView *)bigView withHeaderView:(UIView *)headerView;
@end

//
//  MNUtils.h
//  GankMM
//
//  Created by 马宁 on 16/5/12.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNUtils : NSObject

/**
 *  保存字符串到粘贴板
 *
 *  @param string 需要保存的文字
 */
+(void)saveToPasteboard:(NSString *)string;

/**
 *  通过苹果外置浏览器打开页面
 *
 *  @param url 地址
 */
+(void)openURLWithBrowser:(NSString *)url;

/**
 *  是否存在网络
 */
+(BOOL)isExistenceNetwork;

/**
 *  是否显示网络标识
 */
+(void)showNetWorkActivityIndicator:(BOOL)flag;

/**
 *  获取设备名字
 */
+(NSString*)getDeviceString;

/**
 *  获取图片的宽高（地址有问题，会阻塞线程）
 *
 *  @param imageUrl 图片的地址
 */
+(UIImage *)getImageWidthAndHeightWithUrl:(NSString *)imageUrl;


@end

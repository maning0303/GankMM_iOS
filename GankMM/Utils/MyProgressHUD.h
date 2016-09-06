//
//  MyProgressHUD.h
//  GankMM
//
//  Created by 马宁 on 16/5/10.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProgressHUD : NSObject

+(void)showToast:(NSString *)message;

+(MBProgressHUD *)showProgressHUDWithInfo:(NSString *)info;

+(void)dissmissProgressHUD;

@end

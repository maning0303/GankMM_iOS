//
//  MyProgressHUD.m
//  GankMM
//
//  Created by 马宁 on 16/5/10.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MyProgressHUD.h"

@implementation MyProgressHUD

static MBProgressHUD *hud;

+(void)showToast:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MNKeyWindow animated:YES];
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    // Move to bottm center.
    [hud setOffset:CGPointMake(0, MNScreenH/2 - 120)];
//    hud.yOffset = MNScreenH/2 - 120;
    [hud hideAnimated:YES afterDelay:1.f];
}

+(MBProgressHUD *)showProgressHUDWithInfo:(NSString *)info
{
    hud = [MBProgressHUD showHUDAddedTo:MNKeyWindow animated:YES];
    hud.label.text = NSLocalizedString(info, @"");
    return hud;
}

+(void)dissmissProgressHUD
{
    if(hud != nil){
        [hud hideAnimated:YES];
    }
}

@end

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
    hud.labelText = message;
    // Move to bottm center.
    hud.yOffset = MNScreenH/2 - 120;
    [hud hide:YES afterDelay:1.f];
}

+(MBProgressHUD *)showProgressHUDWithInfo:(NSString *)info
{
    hud = [MBProgressHUD showHUDAddedTo:MNKeyWindow animated:YES];
    hud.labelText = NSLocalizedString(info, @"");
    return hud;
}

+(void)dissmissProgressHUD
{
    if(hud != nil){
        [hud hide:YES];
    }
}

@end

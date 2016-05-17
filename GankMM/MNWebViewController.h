//
//  MNWebViewController.h
//  GankMM
//
//  Created by 马宁 on 16/5/10.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GankModel;

@interface MNWebViewController : UIViewController

@property(nonatomic,strong)GankModel *gankModel;

@property(nonatomic,strong)NSString *url;

@end

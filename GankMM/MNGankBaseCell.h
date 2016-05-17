//
//  MNGankBaseCell.h
//  GankMM
//
//  Created by 马宁 on 16/5/10.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GankModel;

@interface MNGankBaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnCollect;

@property(nonatomic,strong)GankModel *gankModel;

@end

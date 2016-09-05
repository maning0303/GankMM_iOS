//
//  MNPicturesCell.h
//  GankMM
//
//  Created by 马宁 on 16/9/5.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GankModel;

@interface MNPicturesCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lableTime;

@property(nonatomic,strong)GankModel *gankModel;
@property(nonatomic,strong)NSString *url;

@end

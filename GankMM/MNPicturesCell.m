//
//  MNPicturesCell.m
//  GankMM
//
//  Created by 马宁 on 16/9/5.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNPicturesCell.h"
#import "GankModel.h"

@implementation MNPicturesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setGankModel:(GankModel *)gankModel
{
    _gankModel = gankModel;
    
    _lableTime.text = [gankModel.publishedAt componentsSeparatedByString:@"T"][0];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:gankModel.url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //获取图片
        _imageView.image = image;
        
    }];
    
}

@end

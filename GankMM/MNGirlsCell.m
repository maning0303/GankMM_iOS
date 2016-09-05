//
//  MNGirlsCell.m
//  GankMM
//
//  Created by 马宁 on 16/5/10.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNGirlsCell.h"
#import "GankModel.h"

@interface MNGirlsCell()

@property (weak, nonatomic) IBOutlet UILabel *lableTime;

@end

@implementation MNGirlsCell

- (void)awakeFromNib {
    //去掉默认效果
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setGankModel:(GankModel *)gankModel
{
    _gankModel = gankModel;
    
    _lableTime.text = [gankModel.publishedAt componentsSeparatedByString:@"T"][0];
    
    [_imageViewShow sd_setImageWithURL:[NSURL URLWithString:gankModel.url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        MNLog(@"%@image:",image);
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(_imageViewShow.size, YES, 0.0);
        //将下载的图片绘制到图形上下文中
        CGFloat width = MNScreenW - 20;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        //获取图片
        _imageViewShow.image = UIGraphicsGetImageFromCurrentImageContext();
        //结束图形上下文
        UIGraphicsEndImageContext();
        
        //赋值图片的高度
        _gankModel.imageH = height;
        
    }];
    
}

@end

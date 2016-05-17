//
//  MNGankCollectCell.m
//  GankMM
//
//  Created by 马宁 on 16/5/12.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNGankCollectCell.h"
#import "GankModel.h"

@interface MNGankCollectCell ()

@property (weak, nonatomic) IBOutlet UILabel *lableTitle;
@property (weak, nonatomic) IBOutlet UILabel *lableType;
@property (weak, nonatomic) IBOutlet UILabel *lableTime;

@end

@implementation MNGankCollectCell

- (void)awakeFromNib {

    
}


-(void)setGankModel:(GankModel *)gankModel
{
    _gankModel = gankModel;
    
    _lableType.text = _gankModel.type;
    _lableTitle.text = _gankModel.desc;
    _lableTitle.textColor = GankMainColor;
    _lableTime.text = [_gankModel.publishedAt componentsSeparatedByString:@"T"][0];
    
}

@end

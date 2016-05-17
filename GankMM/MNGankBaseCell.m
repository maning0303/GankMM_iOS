//
//  MNGankBaseCell.m
//  GankMM
//
//  Created by 马宁 on 16/5/10.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNGankBaseCell.h"
#import "GankModel.h"
#import "MNGankDao.h"

@interface MNGankBaseCell()

@property (weak, nonatomic) IBOutlet UILabel *lableTitle;
@property (weak, nonatomic) IBOutlet UILabel *lableWho;
@property (weak, nonatomic) IBOutlet UILabel *lableTime;

@end

@implementation MNGankBaseCell

-(void)setGankModel:(GankModel *)gankModel
{
    _gankModel = gankModel;
    
    _lableWho.text = _gankModel.who;
    _lableTitle.text = _gankModel.desc;
    _lableTitle.textColor = GankMainColor;
    _lableTime.text = [_gankModel.publishedAt componentsSeparatedByString:@"T"][0];
    
    if(_gankModel.collect){
        [_btnCollect setSelected:YES];
    }else{
        [_btnCollect setSelected:NO];
    }

}

- (void)awakeFromNib {

    
}


- (IBAction)modifyCollectState:(id)sender {
    if(_gankModel.collect){
        MNLog(@"取消收藏");
        //删除数据库数据
        BOOL result = [MNGankDao deleteOne:_gankModel._id];
        if(result){
            [_btnCollect setSelected:NO];
            _gankModel.collect = NO;
            [MyProgressHUD showToast:@"取消收藏成功"];
        }else{
            [MyProgressHUD showToast:@"取消收藏失败"];
        }
    }else{
         MNLog(@"收藏");
        //插入数据库
        BOOL result = [MNGankDao save:_gankModel];
        if(result){
            [_btnCollect setSelected:YES];
            _gankModel.collect = YES;
            [MyProgressHUD showToast:@"收藏成功"];
        }else{
            [MyProgressHUD showToast:@"收藏失败"];
        }
        
    }
   
    
}

@end

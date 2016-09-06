//
//  JGWaterflowLayout.h
//  瀑布流
//
//  Created by 郭军 on 16/8/13.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGWaterflowLayout;

@protocol JGWaterflowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowlayout:(JGWaterflowLayout *)waterlayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;
@optional
- (CGFloat)columnCountInWaterflowLayout:(JGWaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(JGWaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(JGWaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(JGWaterflowLayout *)waterflowLayout;

@end


@interface JGWaterflowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<JGWaterflowLayoutDelegate> delegate;


@end

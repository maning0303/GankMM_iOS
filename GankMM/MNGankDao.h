//
//  MNGankDao.h
//  GankMM
//
//  Created by 马宁 on 16/5/11.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GankModel;

@interface MNGankDao : NSObject

//-------------collect表--------------
/**
 *  保存到数据库
 */
+(BOOL)save:(GankModel *)gankModel;

/**
 *  通过ID查询这条数据是不是在数据库中
 */
+(BOOL)queryIsExist:(NSString *)_id;

+(NSArray *)queryWithType:(NSString *)type;

+(NSArray *)queryAll;

+(BOOL)deleteOne:(NSString *)_id;

+(void)deleteAll;

//-------------cache表--------------
+(void)saveCache:(NSArray *)gankLists type:(NSString *)type;

+(void)deleteCacheWithType:(NSString *)type;

+(NSArray *)queryCacheWithType:(NSString *)type;

@end

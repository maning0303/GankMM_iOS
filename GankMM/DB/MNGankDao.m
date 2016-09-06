//
//  MNGankDao.m
//  GankMM
//
//  Created by 马宁 on 16/5/11.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNGankDao.h"
#import <sqlite3.h>
#import "GankModel.h"

@implementation MNGankDao

static sqlite3 *_db = nil;

+(void)initialize
{
    //获取数据库文件路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbName = [doc stringByAppendingPathComponent:@"gank.sqlite"];
    //将OC字符串转换为 C 语言的字符串
    const char *cdbName = dbName.UTF8String;
    //1.打开数据库(如果不存在就创建)
    int result = sqlite3_open(cdbName, &_db);
    if(SQLITE_OK == result){    //打开成功
        NSLog(@"%@数据库打开成功",dbName);
        //创建表
        [MNGankDao createCollectTable];
        [MNGankDao createCacheTable];
        
    }else{
        NSLog(@"打开数据库失败---%zd",result);
    }

}

/**
 *  打开数据库
 */
+(sqlite3 *)open
{
    // 懒加载
    if (_db != nil) {
        return _db;
    }
    
    //获取数据库文件路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbName = [doc stringByAppendingPathComponent:@"gank.sqlite"];
    //将OC字符串转换为 C 语言的字符串
    const char *cdbName = dbName.UTF8String;
    //1.打开数据库(如果不存在就创建)
    sqlite3_open(cdbName, &_db);
    
    return _db;
}

+(void)createCollectTable
{
    //打开数据库
    [MNGankDao open];
    
    //创建表
    const char *sql = "CREATE TABLE if not exists t_gank_collect (id integer primary key autoincrement , _id text not null , source text,who text,publishedAt text,type text,desc text,url text)";
    char *erroMsg = NULL;
    //执行语句
    int result = sqlite3_exec(_db, sql, NULL, NULL, &erroMsg);
    if(SQLITE_OK == result){
        NSLog(@"Collect表创建成功");
    }else {
        NSLog(@"Collect表创建失败---%s",erroMsg);
    }
    
    //关闭
    [MNGankDao close];
    
}

+(void)createCacheTable
{
    //打开数据库
    [MNGankDao open];
    
    //创建表
    const char *sql = "CREATE TABLE if not exists t_gank_cache (id integer primary key autoincrement , _id text not null , source text,who text,publishedAt text,type text,desc text,url text)";
    char *erroMsg = NULL;
    //执行语句
    int result = sqlite3_exec(_db, sql, NULL, NULL, &erroMsg);
    if(SQLITE_OK == result){
        NSLog(@"Cache表创建成功");
    }else {
        NSLog(@"Cache表创建失败---%s",erroMsg);
    }
    
    //关闭
    [MNGankDao close];
    
}

// 关闭数据库
+ (void)close {
    // 关闭数据库
    sqlite3_close(_db);
    // 将数据库的指针置空
    _db = nil;
}

//---------------------华丽分界线----------------------------

+(BOOL)save:(GankModel *)gankModel
{
    BOOL result = [MNGankDao queryIsExist:gankModel._id];
    if(result){
        MNLog(@"已经存在了");
        return YES;
    }
    
    [MNGankDao open];
    
    NSString *sql = [NSString stringWithFormat:@"insert into t_gank_collect (_id,source,who,publishedAt,type,desc,url) values ('%@','%@','%@','%@','%@','%@','%@')",gankModel._id,gankModel.source,gankModel.who,gankModel.publishedAt,gankModel.type,gankModel.desc,gankModel.url];
    
    //执行语句
    char *erroMsg = NULL;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &erroMsg);
    if(erroMsg){
        NSLog(@"插入数据失败---%s",erroMsg);
    }else{
        NSLog(@"插入数据成功");
        result = YES;
    }
    //关闭
    [MNGankDao close];
    
    return result;
}

+(BOOL)queryIsExist:(NSString *)_id
{
    
    BOOL result = NO;
    
    [MNGankDao open];
    
    NSString *sql = [NSString stringWithFormat:@"select _id from t_gank_collect where _id like '%@'",_id];
    sqlite3_stmt *stmt = NULL;
    if(sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK){
        NSLog(@"查询语句没有问题");
        // 每调一次sqlite3_step函数，stmt就会指向下一条记录
        if (sqlite3_step(stmt) == SQLITE_ROW) { // 找到一条记录
            // 取出第0列字段的值
            const unsigned char *_id = sqlite3_column_text(stmt, 0);
            if(_id != nil){
                result = YES;
            }
        }
    }else{
        NSLog(@"查询语句有问题");
    }
    //销毁资源
    sqlite3_finalize(stmt);
    [MNGankDao close];
    
    return result;
}

+(NSArray *)queryWithType:(NSString *)type
{
    NSMutableArray *results = [NSMutableArray array];
    
    [MNGankDao open];
    
    NSString *sql = [NSString stringWithFormat:@"select _id,source,who,publishedAt,type,desc,url from t_gank_collect where type like '%@'",type];
    sqlite3_stmt *stmt = NULL;
    if(sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK){
        NSLog(@"查询语句没有问题");
        
        results = [MNGankDao readDbToAraay:stmt];
        
    }else{
        NSLog(@"查询语句有问题");
    }
    //销毁资源
    sqlite3_finalize(stmt);
    [MNGankDao close];
    
    return results;
}


+(NSArray *)queryAll
{
    NSMutableArray *results = [NSMutableArray array];
    
    [MNGankDao open];
    
    NSString *sql = [NSString stringWithFormat:@"select _id,source,who,publishedAt,type,desc,url from t_gank_collect"];
    sqlite3_stmt *stmt = NULL;
    if(sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK){
        NSLog(@"查询语句没有问题");
        
        results = [MNGankDao readDbToAraay:stmt];
        
    }else{
        NSLog(@"查询语句有问题");
    }
    //销毁资源
    sqlite3_finalize(stmt);
    [MNGankDao close];
    
    return results;
}


+(BOOL)deleteOne:(NSString *)_id
{
    BOOL result = NO;
    
    [MNGankDao open];
    sqlite3_stmt *stmt = NULL;
    //sql语句格式: delete from 表名 where 列名 ＝ 参数     注：后面的 列名 ＝ 参数 用于判断删除哪条数据
    NSString *sql = [NSString stringWithFormat:@"delete from t_gank_collect where _id = '%@'",_id];
    
    int deleteResult = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, nil);
    
    if (deleteResult != SQLITE_OK) {
        NSLog(@"删除失败,%d",deleteResult);
    }else{
        sqlite3_step(stmt);
        result = YES;
    }
    
    //销毁资源
    sqlite3_finalize(stmt);
    [MNGankDao close];
    
    return result;
}

+(void)deleteAll
{
    //打开数据库
    [MNGankDao open];
    
    sqlite3_stmt *stmt = NULL;
    //sql语句格式: delete from 表名 where 列名 ＝ 参数     注：后面的 列名 ＝ 参数 用于判断删除哪条数据
    NSString *sql = [NSString stringWithFormat:@"delete from t_gank_collect"];
    int deleteResult = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, nil);
    
    if (deleteResult != SQLITE_OK) {
        NSLog(@"删除失败,%d",deleteResult);
    }else{
        sqlite3_step(stmt);
        
    }
    
    //销毁资源
    sqlite3_finalize(stmt);
    
    [MNGankDao close];
}


//--------------------抽取公用

+(NSMutableArray *)readDbToAraay:(sqlite3_stmt *)stmt
{
    NSMutableArray *results = [NSMutableArray array];
    GankModel *gankModel;
    // 每调一次sqlite3_step函数，stmt就会指向下一条记录
    while (sqlite3_step(stmt) == SQLITE_ROW) { // 找到一条记录
        // 取出第0列字段的值
        const unsigned char *_id = sqlite3_column_text(stmt, 0);
        const unsigned char *source = sqlite3_column_text(stmt, 1);
        const unsigned char *who = sqlite3_column_text(stmt, 2);
        const unsigned char *publishedAt = sqlite3_column_text(stmt, 3);
        const unsigned char *type = sqlite3_column_text(stmt, 4);
        const unsigned char *desc = sqlite3_column_text(stmt, 5);
        const unsigned char *url = sqlite3_column_text(stmt, 6);
        
        //创建对象
        gankModel = [[GankModel alloc] init];
        gankModel._id = [NSString stringWithUTF8String:(const char *)_id];
        gankModel.source = [NSString stringWithUTF8String:(const char *)source];
        gankModel.who = [NSString stringWithUTF8String:(const char *)who];
        gankModel.publishedAt = [NSString stringWithUTF8String:(const char *)publishedAt];
        gankModel.type = [NSString stringWithUTF8String:(const char *)type];
        gankModel.desc = [NSString stringWithUTF8String:(const char *)desc];
        gankModel.url = [NSString stringWithUTF8String:(const char *)url];
        
        //添加到集合
        [results addObject:gankModel];
        
    }
    
    return results;
}

//---------------------


//----------------------保存缓存表 t_gank_cache------------------------

+(void)saveCache:(NSArray *)gankLists type:(NSString *)type
{
    //先删除保存过的缓存再重新保存
    [MNGankDao deleteCacheWithType:type];
    
    //打开数据库
    [MNGankDao open];
    
    GankModel *gankModel;
    for (int i =0 ; i<gankLists.count; i++) {
        gankModel = gankLists[i];
        NSString *sql = [NSString stringWithFormat:@"insert into t_gank_cache (_id,source,who,publishedAt,type,desc,url) values ('%@','%@','%@','%@','%@','%@','%@')",gankModel._id,gankModel.source,gankModel.who,gankModel.publishedAt,gankModel.type,gankModel.desc,gankModel.url];
        //执行语句
        char *erroMsg = NULL;
        sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &erroMsg);
        if(erroMsg){
            NSLog(@"插入数据失败---%s",erroMsg);
        }else{
            NSLog(@"插入数据成功");
        }
    }
    
    [MNGankDao close];
    
}

+(void)deleteCacheWithType:(NSString *)type
{
    //打开数据库
    [MNGankDao open];
    
    sqlite3_stmt *stmt = NULL;
    //sql语句格式: delete from 表名 where 列名 ＝ 参数     注：后面的 列名 ＝ 参数 用于判断删除哪条数据
    NSString *sql = [NSString stringWithFormat:@"delete from t_gank_cache where type = '%@'",type];
    
    int deleteResult = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, nil);
    
    if (deleteResult != SQLITE_OK) {
        NSLog(@"删除失败,%d",deleteResult);
    }else{
        sqlite3_step(stmt);

    }
    
    //销毁资源
    sqlite3_finalize(stmt);
    
    [MNGankDao close];

}

+(NSArray *)queryCacheWithType:(NSString *)type
{
    NSMutableArray *results = [NSMutableArray array];
    
    [MNGankDao open];
    
    NSString *sql = [NSString stringWithFormat:@"select _id,source,who,publishedAt,type,desc,url from t_gank_cache where type like '%@'",type];
    sqlite3_stmt *stmt = NULL;
    if(sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK){
        NSLog(@"查询语句没有问题");
        
        results = [MNGankDao readDbToAraay:stmt];
        
    }else{
        NSLog(@"查询语句有问题");
    }
    //销毁资源
    sqlite3_finalize(stmt);
    [MNGankDao close];
    
    return results;
}



@end

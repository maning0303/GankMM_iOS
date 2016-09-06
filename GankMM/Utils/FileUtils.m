//
//  FileUtils.m
//  GankMM
//
//  Created by 马宁 on 16/5/12.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils

//存放体积大又不需要备份的数据
+ (NSString *)cacheDir
{
    // 1.获取caches目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return path;
}


//保存应用程序本身运行时产生的文件或者数据，iCloud备份目录，例如：游戏进度、涂鸦软件的绘图
//注意点：不要保存从网络上下载的文件，否则会无法上架！
+ (NSString *)docDir
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return path;
}

//存放临时文件，不会被备份，而且这个文件下的数据有可能随时被清除的可能
+ (NSString *)tmpDir
{
    NSString *path = NSTemporaryDirectory();
    return path;
}

//----------------------------------------------

+(NSString *)getDocumentPath:(NSString *)fileName
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    // 拼接要保存的地方的路径
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

+(BOOL)deleteDocumentFile:(NSString *)fileName
{
    //获取路径
    NSString *filePath = [FileUtils getDocumentPath:fileName];
    NSFileManager *manager=[NSFileManager defaultManager];
    if ([manager removeItemAtPath:filePath error:nil]) {
        NSLog(@"文件删除成功");
        return YES;
    }else{
        NSLog(@"文件删除失败");
        return NO;
    }
}

+(void)savePlist:(NSString *)fileName withDict:(NSDictionary *)dict
{
    //获取路径
    NSString *filePath = [FileUtils getDocumentPath:fileName];
    // 将字典持久化到Documents文件中
    [dict writeToFile:filePath atomically:YES];
}

+(NSDictionary *)getPlist:(NSString *)fileName
{
    //获取路径
    NSString *filePath = [FileUtils getDocumentPath:fileName];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return dict;
}

//------------------------NSUserDefaults 偏好设置----------------------------START
//保存应用的所有偏好设置，iCloud会备份设置信息

+(void)saveBoolToPreference:(BOOL)flag withKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:flag forKey:key];
    // 强制写入
    [userDefaults synchronize];
}
+(void)saveObjectToPreference:(NSObject *)value withKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    // 强制写入
    [userDefaults synchronize];
}
+(void)saveFloatToPreference:(float)value withKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:value forKey:key];
    // 强制写入
    [userDefaults synchronize];
}
+(void)saveIntegerToPreference:(NSInteger)value withKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:key];
    // 强制写入
    [userDefaults synchronize];
}

+(BOOL)getBoolFromPreferenceKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+(float)getFloatFromPreferenceKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults floatForKey:key];
}

+(NSObject *)getObjectFromPreferenceKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+(NSInteger)getIntegerFromPreferenceKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}

//------------------------NSUserDefaults 偏好设置----------------------------END

+(void)saveArchiver:(NSString *)fileName withObject:(NSObject *)object
{
    NSString *filePath = [FileUtils getDocumentPath:fileName];
    [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

+(NSObject *)getArchiver:(NSString *)fileName
{
    NSString *filePath = [FileUtils getDocumentPath:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

//------------------------保存图片

+(void)saveImageToLocal:(UIImage *)image imageName:(NSString *)imageName
{
    //设置一个图片的存储路径
    NSString *imagePath = [FileUtils getDocumentPath:imageName];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}

+(UIImage *)getImageFromLocalImageName:(NSString *)imageName
{
    NSString *filePath = [FileUtils getDocumentPath:imageName];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    return img;
}


@end

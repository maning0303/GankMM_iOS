//
//  FileUtils.h
//  GankMM
//
//  Created by 马宁 on 16/5/12.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

// 用于生成文件在caches目录中的路径
+ (NSString *)cacheDir;
// 用于生成文件在document目录中的路径
+ (NSString *)docDir;
// 用于生成文件在tmp目录中的路径
+ (NSString *)tmpDir;



/**
 *  获取Document文件的路径
 *
 *  @param fileName 文件名字
 *
 *  @return 文件的路径
 */
+(NSString *)getDocumentPath:(NSString *)fileName;

/**
 *  删除Document下的文件
 *
 *  @param fileName 文件名字
 *
 *  @return 删除是否成功
 */
+(BOOL)deleteDocumentFile:(NSString *)fileName;

/**
 *  保存Plist到Document目录下
 *
 *  @param fileName 文件的名字
 *  @param dict     要保存的数据
 */
+(void)savePlist:(NSString *)fileName withDict:(NSDictionary *)dict;

/**
 *  获取plist文件
 *
 *  @param fileName 文件名字
 */
+(NSDictionary *)getPlist:(NSString *)fileName;


//------------------------NSUserDefaults 偏好设置----------------------------START

+(void)saveBoolToPreference:(BOOL)flag withKey:(NSString *)key;
+(void)saveObjectToPreference:(NSObject *)value withKey:(NSString *)key;
+(void)saveFloatToPreference:(float)value withKey:(NSString *)key;
+(void)saveIntegerToPreference:(NSInteger)value withKey:(NSString *)key;

+(BOOL)getBoolFromPreferenceKey:(NSString *)key;
+(NSObject *)getObjectFromPreferenceKey:(NSString *)key;
+(float)getFloatFromPreferenceKey:(NSString *)key;
+(NSInteger)getIntegerFromPreferenceKey:(NSString *)key;

//------------------------Archiver----------------------------END

+(void)saveArchiver:(NSString *)fileName withObject:(NSObject *)object;
+(NSObject *)getArchiver:(NSString *)fileName;

//---------------------保存图片
/**
 *  保存图片到本地
 */
+(void)saveImageToLocal:(UIImage *)image imageName:(NSString *)imageName;

+(UIImage *)getImageFromLocalImageName:(NSString *)imageName;

@end

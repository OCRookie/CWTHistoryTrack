//
//  CMCCIOTFileManager.h
//  CMCCIOTAppKit
//  文件管理操作类，一些基本的文件或者文件夹操作接口在这里
//  Created by BigKrist on 15/4/20.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCCIOTFileManager : NSObject

/**
 *  获取文件管理操作类的单例对象
 *
 *  @return CMCCIOTFileManager实例返回
 */
+ (instancetype)shareInstance;



/**
 *  获取沙盒中Library/Cache文件夹的路径
 *
 *  @return 返回沙盒中Library/Cache的真实文件夹路径
 */
- (NSString*)cmcciotGetAppCacheDirPath;


/**
 *  获取沙盒中Document文件夹的路径
 *
 *  @return 返回沙盒中的Document的真实文件夹路径
 */
- (NSString*)cmcciotGetAppDocumentDirPath;



/**
 *  获取沙盒中的Tmp文件夹路径
 *
 *  @return 返回沙盒中的Tmp真实文件夹路径
 */
- (NSString*)cmcciotGetAppTmpDirPath;


/**
 *  迭代删除给定的文件夹中的所有文件和文件夹
 *
 *  @param directoryPath 要删除的文件夹
 */
- (void)cmcciotDeleteTheFilesInDirectory:(NSString *)directoryPath;

/**
 *  获取指定文件路径的文件的大小
 *
 *  @param filePath 指定的文件的路径（不能是文件夹路径）
 *
 *  @return 指定路径的文件大小
 */
- (long long)cmcciotFileSizeAtPath:(NSString*)filePath;
@end

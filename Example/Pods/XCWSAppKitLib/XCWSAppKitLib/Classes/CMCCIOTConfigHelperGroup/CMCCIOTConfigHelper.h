//
//  CMCCIOTConfigHelper.h
//  CMCCIOTAppKit
//  配置管理帮助类, 读取和写入本地配置的操作类
//  Created by BigKrist on 15/4/20.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMCCIOTAppKitDelegate.h"
#import "CMCCIOTEncryption.h"

@interface CMCCIOTConfigHelper : NSObject

/**
 *  返回配置管理类的单例对象
 *
 *  @return CMCCIOTConfigHelper的单
 */
+ (instancetype)shareInstance;

/**
 *  获取本地配置文件夹的路径
 *
 *  @return 本地配置文件夹的路径,获取失败则返回nil
 */
- (NSString*)cmcciotGetLocalConfigDirPath;

/**
 *  根据送入的文件名来返回编码文件名之后的本地文件配置路径
 *
 *  @param targetFileName 目标配置文件名
 *
 *  @return 返回文件名编码之后的文件路径，如果操作失败则返回nil
 */
- (NSString*)cmcciotGetEncodedFilePathWith:(NSString *)targetFileName;

/**
 *  获取指定的配置文件的中的配置数据
 *
 *  @param targetFileName 指定的目标文件名
 *
 *  @return 返回指定文件名的NSMutableDictionary数据，如果没有指定文件则返回空的NSMutableDictionary
 */
- (NSMutableDictionary*)cmcciotGetLocalConfigDicInfoWith:(NSString*)targetFileName;


/**
 *  获取指定配置文件中的指定配置键位的配置值
 *
 *  @param targetKey      要获取的配置键位
 *  @param targetFileName 要获取的配置文件名称
 *
 *  @return 返回指定配置文件中的指定配置键位的配置值
 */
- (id)cmcciotGetConfigValueByKey:(NSString*)targetKey
               andConfigFileName:(NSString*)targetFileName;


/**
 *  更新指定配置文件中的指定配置键位的值
 *
 *  @param targetValue    要更新的最新值
 *  @param targetKey      要更新的指定键位
 *  @param targetFileName 要更新的指定的配置文件名称
 *
 *  @return 是否更新成功, YES表示成功， NO表示更新失败
 */
- (BOOL)cmcciotUpdateTheConfigValueWith:(id)targetValue
                                  ofKey:(NSString*)targetKey
                      andConfigFileName:(NSString*)targetFileName;


/**
 *  删除制定配置文件中的指定键位
 *
 *  @param targetKey      要删除的指定键位
 *  @param targetFileName 要删除的配置文件的名称
 *
 *  @return 删除的结果，YES表示删除成功， NO表示删除失败
 */
- (BOOL)cmcciotRemoveConfigValueOfKey:(NSString *)targetKey
                    andConfigFileName:(NSString *)targetFileName;


/**
 *  删除制定配置文件名中的所有配置信息
 *
 *  @param targetFileName 要进行键位删除的目标配置文件名称
 *
 *  @return 删除操作的结果，YES表示删除成功， NO表示删除操作失败
 */
- (BOOL)cmcciotRemoveAllConfigValueInConfigFileName:(NSString *)targetFileName;


/**
 *  将指定的NSDictionary数据加密后写入到指定的路径
 *
 *  @param targetDicToWrite 需要加密写入的数据
 *  @param targetFilePath   需要写到的目标地址路径
 *
 *  @return 是否写入成功 YES表示成功， NO表示失败
 */
- (BOOL)cmcciotWriteTheTargetDic:(NSDictionary*)targetDicToWrite
                toAESEncryToPath:(NSString*)targetFilePath;
@end

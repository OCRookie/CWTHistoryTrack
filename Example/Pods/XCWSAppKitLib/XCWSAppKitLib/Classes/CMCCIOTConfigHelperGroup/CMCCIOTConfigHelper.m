//
//  CMCCIOTConfigHelper.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/20.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTConfigHelper.h"

static CMCCIOTConfigHelper *globalConfigHelper;

@implementation CMCCIOTConfigHelper

+ (instancetype)shareInstance
{
    if(globalConfigHelper == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            globalConfigHelper = [[CMCCIOTConfigHelper alloc] init];
        });
    }
    
    return globalConfigHelper;
}


- (NSString*)cmcciotGetLocalConfigDirPath
{
    NSArray *documentsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if(documentsArray == nil)
        return nil;
    
    NSString *documentRootPath = [documentsArray objectAtIndex:0];
    NSString *configPath = @".config";
    NSString *configDirPath = [documentRootPath stringByAppendingPathComponent:configPath];
    BOOL isDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(!([fileManager fileExistsAtPath:configDirPath isDirectory:&isDir] && isDir))
        [fileManager createDirectoryAtPath:configDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return configDirPath;
}


- (NSString*)cmcciotGetEncodedFilePathWith:(NSString *)targetFileName
{
    NSString *documentDirPath = [[CMCCIOTConfigHelper shareInstance] cmcciotGetLocalConfigDirPath];
    NSString *targetFileBase64Name = [NSData cmcciotBase64encode:targetFileName];
    NSString *encodedFilePath = [documentDirPath stringByAppendingPathComponent:targetFileBase64Name];
    return encodedFilePath;
}


- (NSMutableDictionary*)cmcciotGetLocalConfigDicInfoWith:(NSString*)targetFileName
{
    NSString *encodedFilePath = [[CMCCIOTConfigHelper shareInstance] cmcciotGetEncodedFilePathWith:targetFileName];
    id appDel = [UIApplication sharedApplication].delegate;
    if(![appDel conformsToProtocol:@protocol(CMCCIOTAppKitDelegate)])
    {
        NSAssert(NO, @"AppDel didn't confirm protocol BKApplicationDelegate");
        return [[NSMutableDictionary alloc] init];
    }
    NSString *appSecretKey = [(id<CMCCIOTAppKitDelegate>)appDel cmcciotGetAppSecrectKey];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:encodedFilePath]) return [[NSMutableDictionary alloc] init];
    NSData *originData = [[NSData alloc] initWithContentsOfFile:encodedFilePath];
    NSData *decriedData = [originData cmcciotAES256DecryptWithKey:appSecretKey];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:decriedData];
    NSDictionary *tempDic = [unarchiver decodeObject];
    [unarchiver finishDecoding];
    return [NSMutableDictionary dictionaryWithDictionary:tempDic];
}


- (id)cmcciotGetConfigValueByKey:(NSString*)targetKey andConfigFileName:(NSString*)targetFileName
{
    NSMutableDictionary *tempTargetDic = [[CMCCIOTConfigHelper shareInstance] cmcciotGetLocalConfigDicInfoWith:targetFileName];
    return [tempTargetDic objectForKey:targetKey];
}


- (BOOL)cmcciotUpdateTheConfigValueWith:(id)targetValue ofKey:(NSString*)targetKey andConfigFileName:(NSString*)targetFileName
{
    CMCCIOTConfigHelper *configHelper = [CMCCIOTConfigHelper shareInstance];
    NSMutableDictionary *tempTargetDic = [configHelper cmcciotGetLocalConfigDicInfoWith:targetFileName];
    [tempTargetDic setObject:targetValue forKey:targetKey];
    NSString *targetEncodedPath = [configHelper cmcciotGetEncodedFilePathWith:targetFileName];
    return [configHelper cmcciotWriteTheTargetDic:tempTargetDic toAESEncryToPath:targetEncodedPath];
}


- (BOOL)cmcciotRemoveConfigValueOfKey:(NSString *)targetKey andConfigFileName:(NSString *)targetFileName
{
    CMCCIOTConfigHelper *configHelper = [CMCCIOTConfigHelper shareInstance];
    NSMutableDictionary *tempTargetDic = [configHelper cmcciotGetLocalConfigDicInfoWith:targetFileName];
    NSString *targetEncodedPath = [configHelper cmcciotGetEncodedFilePathWith:targetFileName];
    [tempTargetDic removeObjectForKey:targetKey];
    return [configHelper cmcciotWriteTheTargetDic:tempTargetDic toAESEncryToPath:targetEncodedPath];
}


- (BOOL)cmcciotRemoveAllConfigValueInConfigFileName:(NSString *)targetFileName
{
    CMCCIOTConfigHelper *configHelper = [CMCCIOTConfigHelper shareInstance];
    NSMutableDictionary *tempTargetDic = [configHelper cmcciotGetLocalConfigDicInfoWith:targetFileName];
    NSString *targetEncodedPath = [configHelper cmcciotGetEncodedFilePathWith:targetFileName];
    [tempTargetDic removeAllObjects];
    return [configHelper cmcciotWriteTheTargetDic:tempTargetDic toAESEncryToPath:targetEncodedPath];
}


- (BOOL)cmcciotWriteTheTargetDic:(NSDictionary*)targetDicToWrite toAESEncryToPath:(NSString*)targetFilePath
{
    NSMutableData *dataToEncry = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataToEncry];
    [archiver encodeObject:targetDicToWrite];
    [archiver finishEncoding];
    
    id appDel = [UIApplication sharedApplication].delegate;
    if(![appDel conformsToProtocol:@protocol(CMCCIOTAppKitDelegate)])
    {
        NSAssert(NO, @"AppDel didn't confirm protocol BKApplicationDelegate");
        return NO;
    }
    NSString *appSecretKey = [(id<CMCCIOTAppKitDelegate>)appDel cmcciotGetAppSecrectKey];
    NSData *encriedData = [dataToEncry cmcciotAES256EncryptWithKey:appSecretKey];
    return [encriedData writeToFile:targetFilePath atomically:YES];
}

@end

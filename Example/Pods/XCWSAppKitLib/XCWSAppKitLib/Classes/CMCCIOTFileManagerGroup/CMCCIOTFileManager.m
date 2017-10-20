//
//  CMCCIOTFileManager.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/20.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTFileManager.h"

static CMCCIOTFileManager *globalFileManager;

@implementation CMCCIOTFileManager

+ (instancetype)shareInstance
{
    if(globalFileManager == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            globalFileManager = [[CMCCIOTFileManager alloc] init];
        });
    }
    
    return globalFileManager;
}


- (NSString*)cmcciotGetAppCacheDirPath
{
    NSArray *fileArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if(fileArray == nil || fileArray.count == 0) return nil;
    return [fileArray objectAtIndex:0];
}


- (NSString*)cmcciotGetAppDocumentDirPath
{
    NSArray *fileArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if(fileArray == nil || fileArray.count == 0) return nil;
    return [fileArray objectAtIndex:0];
}


- (NSString*)cmcciotGetAppTmpDirPath
{
    return NSTemporaryDirectory();
}


- (void)cmcciotDeleteTheFilesInDirectory:(NSString *)directoryPath
{
    //删除在临时文件夹里面的文件
    CMCCIOTFileManager *cmccFileManager = [CMCCIOTFileManager shareInstance];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if([fileManager fileExistsAtPath:directoryPath isDirectory:&isDir])
    {
        //当文件存在才进行迭代处理，不存在就不处理
        if(isDir)
        {
            NSArray *tempFileArray = [fileManager contentsOfDirectoryAtPath:directoryPath error:nil];
            if(tempFileArray == nil) return;
            if(tempFileArray.count == 0 && ![directoryPath isEqualToString:NSTemporaryDirectory()])
            {
                [fileManager removeItemAtPath:directoryPath error:nil];
                //NSLog(@"删除文件夹 --> %@",directoryPath);
                return;
            }
            NSEnumerator *fileEnum = [tempFileArray objectEnumerator];
            NSString *fileName;
            while ((fileName = [fileEnum nextObject]) != nil) {
                [cmccFileManager cmcciotDeleteTheFilesInDirectory:[directoryPath stringByAppendingPathComponent:fileName]];
            }
            if(![directoryPath isEqualToString:NSTemporaryDirectory()])
            {
                //NSLog(@"删除文件夹 --> %@",directoryPath);
                [fileManager removeItemAtPath:directoryPath error:nil];
            }
        }
        else
        {
            //当是一个文件则删除
            [fileManager removeItemAtPath:directoryPath error:nil];
            //NSLog(@"删除->%@",directoryPath);
        }
    }
}


- (long long)cmcciotFileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end

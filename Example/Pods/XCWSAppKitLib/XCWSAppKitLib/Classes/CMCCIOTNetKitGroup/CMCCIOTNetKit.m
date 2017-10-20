//
//  CMCCIOTNetKit.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/20.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTNetKit.h"
#import "AFNetworking.h"
//#import "CMCCIOTAppKitDelegate.h"
#import "CMCCIOTAppKit.h"


static CMCCIOTNetKit *globalCMCCIOTNetKit;

@interface CMCCIOTNetKit ()
{
    AFURLSessionManager *afSessionManager;
}
- (void)runSuccessBlockWith:(id)targetRetValue andSuccessBlock:(void (^)(id))successBlock;
- (void)runFailBlockWith:(NSError*)targetError andContextInfo:(id)targetContextInfo andFailBlock:(void (^)(NSError *, id))failBlock;
- (BOOL)checkCMCCAppKitDelegateWith:(void (^)(NSError *, id))failBlock;
- (NSString*)getCMCCAppKitBaseServerUrl;
- (void)addCommonHeaderValueTo:(NSMutableURLRequest*)targetHTTPUrlRequest;
- (id)getCMCCJsonNetRetWith:(NSString*)targetApiName andResponseObj:(id)responseObject andFailBlock:(void (^)(NSError *, id))failBlock;
- (AFURLSessionManager*)getAFSeesionManager;
@end

@implementation CMCCIOTNetKit

+ (instancetype)shareInstance
{
    if(globalCMCCIOTNetKit == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            globalCMCCIOTNetKit = [[CMCCIOTNetKit alloc] init];
        });
    }
    
    return globalCMCCIOTNetKit;
}

- (AFURLSessionManager*)getAFSeesionManager
{
    if(afSessionManager != nil)
        return afSessionManager;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    afSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    afSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return afSessionManager;
}

- (void)runSuccessBlockWith:(id)targetRetValue
            andSuccessBlock:(void (^)(id))successBlock
{
    //保证正确的闭包块在主线程中运行
    if(successBlock == nil) return;
    if([NSThread currentThread].isMainThread)
        successBlock(targetRetValue);
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock(targetRetValue);
        });
    }
}


- (void)runFailBlockWith:(NSError *)targetError
          andContextInfo:(id)targetContextInfo
            andFailBlock:(void (^)(NSError *, id))failBlock
{
    //保证错误的闭包块在主线程中运行
    if(failBlock == nil) return;
    if([NSThread currentThread].isMainThread)
        failBlock(targetError,targetContextInfo);
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            failBlock(targetError,targetContextInfo);
        });
    }
}


- (NSString*)getCMCCAppKitBaseServerUrl
{
    //获取App中提供的基准服务器地址
    id appDel = [UIApplication sharedApplication].delegate;
    NSString *baseUrl = [(id<CMCCIOTAppKitDelegate>)appDel cmcciotGetAppBaseServerUrl];
    return baseUrl;
}


- (BOOL)checkCMCCAppKitDelegateWith:(void (^)(NSError *, id))failBlock
{
    id appDel = [UIApplication sharedApplication].delegate;
    if(![appDel conformsToProtocol:@protocol(CMCCIOTAppKitDelegate)])
    {
        //不满足基础APP协议，无法取到服务器基准地址，错误返回
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKitDelegate Check Domain" code:-1 userInfo:@{@"errorDes":@"UIApplication didn't comform the CMCCIOTAppKitDelegate"}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return NO;
    }
    
    NSString *baseUrl = [(id<CMCCIOTAppKitDelegate>)appDel cmcciotGetAppBaseServerUrl];
    if(baseUrl == nil)
    {
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKitDelegate Check Domain" code:-2 userInfo:@{@"errorDes":@"UIApplication provide nil base url"}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return NO;
    }
    
    return YES;
}


- (void)addCommonHeaderValueTo:(NSMutableURLRequest *)targetHTTPUrlRequest
{
    //在这里添加统一的请求Header
    [targetHTTPUrlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

}


- (id)getCMCCJsonNetRetWith:(NSString*)targetApiName andResponseObj:(id)responseObject andFailBlock:(void (^)(NSError *, id))failBlock
{
    //统一判断返回值是否错误
    if(responseObject == nil)
    {
        //返回值为空
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKit Net Domain" code:-3 userInfo:@{@"errorDes":[NSString stringWithFormat:@"%@: responseObject is nil",targetApiName]}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return nil;
    }
    
    if(![responseObject isKindOfClass:[NSData class]])
    {
        //返回值类型错误
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKit Net Domain" code:-4 userInfo:@{@"errorDes":[NSString stringWithFormat:@"%@: responseObject is not NSData type",targetApiName]}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return nil;
    }
    
    
    
    NSError *convertJsonError;
    id retJsonValue = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&convertJsonError];
    if(retJsonValue == nil || convertJsonError != nil)
    {
        //返回值无法转换为Json对象
        NSString *errorJsonRet = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *retError = nil;
        if(errorJsonRet != nil)
            retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKit Net Domain" code:-4 userInfo:@{@"errorDes":[NSString stringWithFormat:@"%@: responseObject can't convert to json, the retStr is %@",targetApiName,errorJsonRet]}];
        else
            retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKit Net Domain" code:-4 userInfo:@{@"errorDes":[NSString stringWithFormat:@"%@: responseObject can't convert to json",targetApiName]}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return nil;
    }
    
    return retJsonValue;
}


- (void)cmcciotInvokeApiWithGetMethond:(NSString *)targetApiName
                             andParams:(NSDictionary *)targetRequestInfo
                       andSuccessBlock:(void (^)(id))successBlock
                          andFailBlock:(void (^)(NSError *, id))failBlock
{
    
}


- (void)cmcciotInvokeApiWithPostMethod:(NSString *)targetApiName
                             andParams:(NSDictionary *)targetRequestInfo
                       andSuccessBlock:(void (^)(id))successBlock
                          andFailBlock:(void (^)(NSError *, id))failBlock
{
    [self cmcciotInvokeApiWithPostMethod:targetApiName andParams:targetRequestInfo andTimeout:30 andSuccessBlock:successBlock andFailBlock:failBlock];
}

- (void)cmcciotInvokeApiWithPostMethod:(NSString *)targetApiName
                             andParams:(NSDictionary *)targetRequestInfo
                            andTimeout:(int )timeOut
                       andSuccessBlock:(void (^)(id))successBlock
                          andFailBlock:(void (^)(NSError *, id))failBlock
{
    if(![self checkCMCCAppKitDelegateWith:failBlock]) return;
    NSString *tempApiName = targetApiName != nil ? targetApiName : @"";
    NSString *baseUrl = [self getCMCCAppKitBaseServerUrl];
    NSString *targetUrlStr = baseUrl;
    if(!([tempApiName isEqualToString:@""] || [[tempApiName stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]))
        targetUrlStr = [NSString stringWithFormat:@"%@%@",baseUrl,tempApiName];

    NSMutableURLRequest *httpRequst = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:targetUrlStr]];
    [httpRequst setHTTPMethod:@"POST"];
    [httpRequst setTimeoutInterval:timeOut];
    [self addCommonHeaderValueTo:httpRequst];
    if(targetRequestInfo != nil && [NSJSONSerialization isValidJSONObject:targetRequestInfo])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:targetRequestInfo options:NSJSONWritingPrettyPrinted error:nil];
        [httpRequst setHTTPBody:jsonData];
    }

    //AF3.0
    AFURLSessionManager *innerSessionManager = [self getAFSeesionManager];
    NSURLSessionDataTask *dataTask = [innerSessionManager dataTaskWithRequest:httpRequst uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error != nil)
        {
            [self runFailBlockWith:error andContextInfo:nil andFailBlock:failBlock];
        }
        else
        {
            id retJsonValue = [self getCMCCJsonNetRetWith:targetApiName andResponseObj:responseObject andFailBlock:failBlock];
            if(retJsonValue == nil) return;
#if CMCCIOTNeedPrintNetRetValue
            NSString *jsonStringToPrint = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if(jsonStringToPrint != nil)
            {
                CMCCIOTLOG(@"%@",@"----------- begin print api invoke --------------------");
                CMCCIOTLOG(@"ThePostApiName is %@ , postValue is %@,  get the retValue is %@",targetApiName,(targetRequestInfo == nil)?@"":targetRequestInfo,jsonStringToPrint);
                CMCCIOTLOG(@"%@",@"----------- end print api invoke ----------------------");
            }
            
#endif
            [self runSuccessBlockWith:retJsonValue andSuccessBlock:successBlock];
        }
    }];
    [dataTask resume];
}

- (void)cmcciotInvokeApiWithFullPostMethodUrl:(NSString*)targetFullUrl
                                    andParams:(NSDictionary*)targetRequestInfo
                              andSuccessBlock:(void (^)(id retValue))successBlock
                                 andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock
{
    if(targetFullUrl == nil && failBlock != nil)
    {
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKitDelegate Check Domain" code:-5 userInfo:@{@"errorDes":@"You'v send a nil targetFullUrl"}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return;
    }
    
    NSMutableURLRequest *httpRequst = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:targetFullUrl]];
    [httpRequst setHTTPMethod:@"POST"];
    httpRequst.timeoutInterval = 30;
    [self addCommonHeaderValueTo:httpRequst];
    if(targetRequestInfo != nil && [NSJSONSerialization isValidJSONObject:targetRequestInfo])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:targetRequestInfo options:NSJSONWritingPrettyPrinted error:nil];
        [httpRequst setHTTPBody:jsonData];
        NSString *jsonStringToUpload = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        CMCCIOTLOG(@"jsonStringToUpload:%@",jsonStringToUpload);
    }
    
    //AF3.0
    AFURLSessionManager *innerSessionManager = [self getAFSeesionManager];
    NSURLSessionDataTask *dataTask = [innerSessionManager dataTaskWithRequest:httpRequst uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error != nil)
        {
            if(error != nil && error.userInfo != nil && [error.userInfo objectForKey:NSLocalizedDescriptionKey] != nil)
            {
                NSString *tempErrorDes = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
                NSError *tempError = [NSError errorWithDomain:tempErrorDes code:error.code userInfo:error.userInfo];
                [self runFailBlockWith:tempError andContextInfo:nil andFailBlock:failBlock];
            }
            else
                [self runFailBlockWith:error andContextInfo:nil andFailBlock:failBlock];
        }
        else
        {
            id retJsonValue = [self getCMCCJsonNetRetWith:targetFullUrl andResponseObj:responseObject andFailBlock:failBlock];
            if(retJsonValue == nil) return;
#if CMCCIOTNeedPrintNetRetValue
            NSString *jsonStringToPrint = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if(jsonStringToPrint != nil)
            {
                CMCCIOTLOG(@"%@",@"----------- begin print api invoke --------------------");
                CMCCIOTLOG(@"ThePostApiName is %@ , postValue is %@,  get the retValue is %@",targetFullUrl,(targetRequestInfo == nil)?@"":targetRequestInfo,jsonStringToPrint);
                CMCCIOTLOG(@"%@",@"----------- end print api invoke ----------------------");
            }
            
#endif
            [self runSuccessBlockWith:retJsonValue andSuccessBlock:successBlock];
        }
    }];
    [dataTask resume];
}

- (void)cmcciotInvokeLushangTypeApiWithFullPostMethodUrl:(NSString*)targetFullUrl
                                               andParams:(NSDictionary*)targetRequestInfo
                                         andSuccessBlock:(void (^)(id retValue))successBlock
                                            andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock
{
    if(targetFullUrl == nil && failBlock != nil)
    {
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKitDelegate Check Domain" code:-5 userInfo:@{@"errorDes":@"You'v send a nil targetFullUrl"}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return;
    }
    
    NSMutableURLRequest *httpRequst = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:targetFullUrl]];
    [httpRequst setHTTPMethod:@"POST"];
    [self addCommonHeaderValueTo:httpRequst];
    if(targetRequestInfo != nil && [NSJSONSerialization isValidJSONObject:targetRequestInfo])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:targetRequestInfo options:NSJSONWritingPrettyPrinted error:nil];
#if CMCCIOTNeedPringJsonStrToPost
        NSString *jsonStrToPost = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        CMCCIOTLOG(@"jsonToTest is ---> %@",jsonStrToPost);
#endif
        [httpRequst setHTTPBody:jsonData];
    }
    
    //AF3.0
    AFURLSessionManager *innerSessionManager = [self getAFSeesionManager];
    NSURLSessionDataTask *dataTask = [innerSessionManager dataTaskWithRequest:httpRequst uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error != nil)
        {
            if(error != nil && error.userInfo != nil && [error.userInfo objectForKey:NSLocalizedDescriptionKey] != nil)
            {
                NSString *tempErrorDes = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
                NSError *tempError = [NSError errorWithDomain:tempErrorDes code:error.code userInfo:error.userInfo];
                [self runFailBlockWith:tempError andContextInfo:nil andFailBlock:failBlock];
            }
            else
                [self runFailBlockWith:error andContextInfo:nil andFailBlock:failBlock];
        }
        else
        {
            id retJsonValue = [self getCMCCJsonNetRetWith:targetFullUrl andResponseObj:responseObject andFailBlock:failBlock];
            if(retJsonValue == nil) return;
#if CMCCIOTNeedPrintNetRetValue
            NSString *jsonStringToPrint = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if(jsonStringToPrint != nil)
            {
                CMCCIOTLOG(@"%@",@"----------- begin print api invoke --------------------");
                CMCCIOTLOG(@"ThePostApiName is %@ , postValue is %@,  get the retValue is %@",targetFullUrl,(targetRequestInfo == nil)?@"":targetRequestInfo,jsonStringToPrint);
                CMCCIOTLOG(@"%@",@"----------- end print api invoke ----------------------");
            }
            
#endif
            
            if(![retJsonValue isKindOfClass:[NSDictionary class]])
            {
                NSError *retError = [[NSError alloc] initWithDomain:@"Lushang server return value error" code:-6 userInfo:@{@"errorDes":@"Lushange server return a not has-map type value"}];
                [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
                return;
            }
            else if([retJsonValue objectForKey:@"result"] == nil)
            {
                NSError *retError = [[NSError alloc] initWithDomain:@"Lushang server return value error" code:-7 userInfo:@{@"errorDes":@"Lushange server return a value without result code"}];
                [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
                return;
            }
            else if([[retJsonValue objectForKey:@"result"] integerValue] != 0)
            {
                //服务器返回的有意义的自定义错误
                NSString *errorDomain = @"Lushang server return value error";
                if([retJsonValue objectForKey:@"note"] != nil && [[retJsonValue objectForKey:@"note"] isKindOfClass:[NSString class]])
                    errorDomain = [retJsonValue objectForKey:@"note"];
                NSError *retError = [[NSError alloc] initWithDomain:errorDomain code:[[retJsonValue objectForKey:@"result"] integerValue] userInfo:retJsonValue];
                [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
                return;
            }
            
            [self runSuccessBlockWith:retJsonValue andSuccessBlock:successBlock];
        }
    }];
    [dataTask resume];
}


- (void)cmcciotInvokeDriveGuardTypeApiWithFullPostMethodUrl:(NSString*)targetFullUrl
                                                  andParams:(NSDictionary*)targetRequestInfo
                                            andSuccessBlock:(void (^)(id retValue))successBlock
                                               andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock
{
    if(targetFullUrl == nil && failBlock != nil)
    {
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKitDelegate Check Domain" code:-5 userInfo:@{@"errorDes":@"You'v send a nil targetFullUrl"}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return;
    }
    
    NSMutableURLRequest *httpRequst = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:targetFullUrl]];
    [httpRequst setHTTPMethod:@"POST"];
    [self addCommonHeaderValueTo:httpRequst];
    if(targetRequestInfo != nil && [NSJSONSerialization isValidJSONObject:targetRequestInfo])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:targetRequestInfo options:NSJSONWritingPrettyPrinted error:nil];
        [httpRequst setHTTPBody:jsonData];
    }
    
    //AF3.0
    AFURLSessionManager *innerSessionManager = [self getAFSeesionManager];
    NSURLSessionDataTask *dataTask = [innerSessionManager dataTaskWithRequest:httpRequst uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error != nil)
        {
            //网络请求失败 modified by wml 20150716
            NSError *retError = [[NSError alloc] initWithDomain:@"网络状况不佳，请稍候再试！" code:-9 userInfo:@{@"errorDes":@"DriveGuard can't connect to server"}];
            [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        }
        else
        {
            id retJsonValue = [self getCMCCJsonNetRetWith:targetFullUrl andResponseObj:responseObject andFailBlock:failBlock];
            if(retJsonValue == nil) return;
#if CMCCIOTNeedPrintNetRetValue
            NSString *jsonStringToPrint = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if(jsonStringToPrint != nil)
            {
                CMCCIOTLOG(@"%@",@"----------- begin print api invoke --------------------");
                CMCCIOTLOG(@"ThePostApiName is %@ , postValue is %@,  get the retValue is %@",targetFullUrl,(targetRequestInfo == nil)?@"":targetRequestInfo,jsonStringToPrint);
                CMCCIOTLOG(@"%@",@"----------- end print api invoke ----------------------");
            }
            
#endif
            
            if(![retJsonValue isKindOfClass:[NSDictionary class]])
            {
                NSError *retError = [[NSError alloc] initWithDomain:@"DriveGuard server return value error" code:-6 userInfo:@{@"errorDes":@"DriveGuard server return a not has-map type value"}];
                [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
                return;
            }
            else if([retJsonValue objectForKey:@"result"] == nil)
            {
                NSError *retError = [[NSError alloc] initWithDomain:@"DriveGuard server return value error" code:-7 userInfo:@{@"errorDes":@"DriveGuard server return a value without result code"}];
                [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
                return;
            }
            else if([[retJsonValue objectForKey:@"result"] integerValue] != 0)
            {
                //服务器返回的有意义的自定义错误
                NSString *errorDomain = @"DriveGuard server return value error";
                if([retJsonValue objectForKey:@"resultNote"] != nil && [[retJsonValue objectForKey:@"resultNote"] isKindOfClass:[NSString class]])
                    errorDomain = [retJsonValue objectForKey:@"resultNote"];
                NSError *retError = [[NSError alloc] initWithDomain:errorDomain code:-8 userInfo:retJsonValue];
                [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
                return;
            }
            
            [self runSuccessBlockWith:retJsonValue andSuccessBlock:successBlock];
        }
    }];
    [dataTask resume];
}



//- (void)cmcciotInvokeLushangTypePostUploadFileMethodUrl:(NSString*)targetFullUrl
//                                       andLocalFileDirPath:(NSString*)targetLocalFileDirPath
//                                            andFileName:(NSString*)targetFileName
//                                            andFileType:(NSString*)targetFileType
//                                            andFileFrom:(NSString*)targetFileFrom
//                                              andFileTo:(NSString*)targetFileTo
//                                       andProgressBlock:(void (^)(float uploadProgress))progressBlock
//                                         andSuccssBlock:(void (^)(id contextInfo))successBlock
//                                           andFailBlock:(void (^)(NSError *error,id contextInfo))failBlock
//{
//    //替换路尚原来的基于ASIHTTPRequest的上传方式， 以方便完全移除迪纳使用的ASIHTTPRequest网络库
//    
//    // 1 构建请求结构
//    if(targetFullUrl == nil && failBlock != nil)
//    {
//        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKitDelegate Check Domain" code:-5 userInfo:@{@"errorDes":@"You'v send a nil targetFullUrl"}];
//        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
//        return;
//    }
//    else if(targetFullUrl == nil) return;
//    
//    if(targetLocalFileDirPath == nil || targetFileName == nil)
//    {
//        if(failBlock != nil)
//        {
//            NSError *retError = [[NSError alloc] initWithDomain:@"文件地址为空" code:-9 userInfo:@{@"errorDes":@"You'v send a nil localFilePath"}];
//            [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
//        }
//        return;
//    }
//    else
//    {
//        NSString *destinaFilePath = [targetLocalFileDirPath stringByAppendingPathComponent:targetFileName];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if(![fileManager fileExistsAtPath:destinaFilePath])
//        {
//            if(failBlock != nil)
//            {
//                NSError *retError = [[NSError alloc] initWithDomain:@"文件地址不存在相应的文件" code:-9 userInfo:@{@"errorDes":@"The loalFilePath does't exists file"}];
//                [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
//            }
//            return;
//        }
//    }
//    
//    NSMutableDictionary *dicToPost = [[NSMutableDictionary alloc] init];
//    if(targetFileName == nil)
//        [dicToPost setObject:@"" forKey:@"name"];
//    else
//        [dicToPost setObject:targetFileName forKey:@"name"];
//    
//    if(targetFileType == nil)
//        [dicToPost setObject:@"" forKey:@"type"];
//    else
//        [dicToPost setObject:targetFileType forKey:@"type"];
//    
//    if(targetFileFrom == nil)
//        [dicToPost setObject:@"" forKey:@"from"];
//    else
//        [dicToPost setObject:targetFileFrom forKey:@"from"];
//    
//    if(targetFileTo == nil)
//        [dicToPost setObject:@"" forKey:@"to"];
//    else
//        [dicToPost setObject:targetFileTo forKey:@"to"];
//    
//    
//    NSString *destinaFilePath = [targetLocalFileDirPath stringByAppendingPathComponent:targetFileName];
//    
//    //正式替换为新的上传方式，采用流式上传，杜绝爆内存隐患
//    [self cmcciotInvokeLushangTypePostUploadCommonMethodUrl:targetFullUrl andLocalFilePath:destinaFilePath andContextInfo:dicToPost andProgressBlock:progressBlock andSuccessBlock:successBlock andFailBlock:failBlock];
//    
//}

- (void)cmcciotInvokeLushangTypePostUploadFileMethodUrl:(NSString*)targetFullUrl
                                       andLocalFileData:(NSData*)targetLocalFileData
                                            andFileName:(NSString*)targetFileName
                                            andFileType:(NSString*)targetFileType
                                            andFileFrom:(NSString*)targetFileFrom
                                              andFileTo:(NSString*)targetFileTo
                                       andProgressBlock:(void (^)(float uploadProgress))progressBlock
                                         andSuccssBlock:(void (^)(id contextInfo))successBlock
                                           andFailBlock:(void (^)(NSError *error,id contextInfo))failBlock
{
    //替换路尚原来的基于ASIHTTPRequest的上传方式， 以方便完全移除迪纳使用的ASIHTTPRequest网络库
    
    // 1 构建请求结构
    if(targetFullUrl == nil && failBlock != nil)
    {
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKitDelegate Check Domain" code:-5 userInfo:@{@"errorDes":@"You'v send a nil targetFullUrl"}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return;
    }
    else if(targetFullUrl == nil) return;
    
    if(targetLocalFileData == nil)
    {
        if(failBlock != nil)
        {
            NSError *retError = [[NSError alloc] initWithDomain:@"文件数据为空" code:-9 userInfo:@{@"errorDes":@"You'v send a nil localFilePath"}];
            [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        }
        return;
    }
    
    NSMutableDictionary *dicToPost = [[NSMutableDictionary alloc] init];
    if(targetFileName == nil)
        [dicToPost setObject:@"" forKey:@"name"];
    else
        [dicToPost setObject:targetFileName forKey:@"name"];
    
    if(targetFileType == nil)
        [dicToPost setObject:@"" forKey:@"type"];
    else
        [dicToPost setObject:targetFileType forKey:@"type"];
    
    if(targetFileFrom == nil)
        [dicToPost setObject:@"" forKey:@"from"];
    else
        [dicToPost setObject:targetFileFrom forKey:@"from"];
    
    if(targetFileTo == nil)
        [dicToPost setObject:@"" forKey:@"to"];
    else
        [dicToPost setObject:targetFileTo forKey:@"to"];
    
    
    //[self cmcciotInvokeLushangTypePostUploadCommonMethodUrl:targetFullUrl andLocalFileData:targetLocalFileData andContextInfo:dicToPost andProgressBlock:progressBlock andSuccessBlock:successBlock andFailBlock:failBlock];
}



@end

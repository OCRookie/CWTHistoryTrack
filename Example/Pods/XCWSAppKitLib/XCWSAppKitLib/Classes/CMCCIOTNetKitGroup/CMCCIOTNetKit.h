//
//  CMCCIOTNetKit.h
//  CMCCIOTAppKit
//  网络操作基础层，在这里进行第三方网络库进行依赖，然后App层对网络层的调用只依赖CMCCIOTNetKit,方便以后对第三方网络库进行更换或者更新
//  Created by BigKrist on 15/4/20.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CMCCIOTNeedPrintNetRetValue 1
#define CMCCIOTNeedPringJsonStrToPost 1

@interface CMCCIOTNetKit : NSObject

/**
 *  获取CMCCIOTNetKit单个实例
 *
 *  @return 返回CMCCIOTNetKit的单例对象
 */
+ (instancetype)shareInstance;



/**
 *  网络基础层的HTTPGet请求
 *
 *  @param targetApiName     要请求的接口Api名称或者路径
 *  @param targetRequestInfo 请求的参数
 *  @param successBlock      请求成功后的闭包块
 *  @param failBlock         请求失败后的闭包块
 */
- (void)cmcciotInvokeApiWithGetMethond:(NSString*)targetApiName
                             andParams:(NSDictionary*)targetRequestInfo
                       andSuccessBlock:(void (^)(id retValue))successBlock
                          andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock;


/**
 *  网络基础层的HTTPPost请求
 *
 *  @param targetApiName     要请求的接口Api名称或者路径
 *  @param targetRequestInfo 要请求的参数
 *  @param successBlock      请求成功后的闭包块
 *  @param failBlock         请求失败后的闭包块
 */
- (void)cmcciotInvokeApiWithPostMethod:(NSString*)targetApiName
                             andParams:(NSDictionary*)targetRequestInfo
                       andSuccessBlock:(void (^)(id retValue))successBlock
                          andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock;

/**
 *  网络基础层的HTTPPost请求
 *
 *  @param targetApiName     要请求的接口Api名称或者路径
 *  @param targetRequestInfo 要请求的参数
 *  @param timeOut           超时时间
 *  @param successBlock      请求成功后的闭包块
 *  @param failBlock         请求失败后的闭包块
 */
- (void)cmcciotInvokeApiWithPostMethod:(NSString*)targetApiName
                             andParams:(NSDictionary*)targetRequestInfo
                            andTimeout:(int )timeOut
                       andSuccessBlock:(void (^)(id retValue))successBlock
                          andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock;

/**
 *  网络基础层的HTTPPost请求，但是送入完整Url地址的实现方式
 *
 *  @param targetFullUrl     要进行http post请求的完整url地址
 *  @param targetRequestInfo 要请求的参数
 *  @param successBlock      请求成功后的闭包块
 *  @param failBlock         请求失败后的闭包块
 */
- (void)cmcciotInvokeApiWithFullPostMethodUrl:(NSString*)targetFullUrl
                                    andParams:(NSDictionary*)targetRequestInfo
                              andSuccessBlock:(void (^)(id retValue))successBlock
                                 andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock;



/**
 *  路尚项目专属的一个Post调用接口，传入完整的URL地址的实现方式，并且对返回值进行一次reuslt判断，如果错误码为非0，那么走failBlock流程
 *
 *  @param targetFullUrl     要进行http post请求的完整url地址
 *  @param targetRequestInfo 要请求的参数
 *  @param successBlock      请求成功后的闭包块
 *  @param failBlock         请求失败后的闭包块
 */
- (void)cmcciotInvokeLushangTypeApiWithFullPostMethodUrl:(NSString*)targetFullUrl
                                               andParams:(NSDictionary*)targetRequestInfo
                                         andSuccessBlock:(void (^)(id retValue))successBlock
                                            andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock;







/**
 *  路尚项目的专属上传文件接口，用于替换迪纳的基于ASIHTTPRequest的文件上传方式
 *
 *  @param targetFullUrl       要进行post上传的目标服务器地址
 *  @param targetLocalFileData 要进行上传的本地文件的NSData数据
 *  @param targetFileName      要上传的文件名
 *  @param targetFileType      要上传的文件类型
 *  @param targetFileFrom      上传源的XMPPID
 *  @param targetFileTo        上传目标的XMPPID
 *  @param progressBlock       上传进度的回调
 *  @param successBlock        上传成功的回调
 *  @param failBlock           上传失败的回调
 */
- (void)cmcciotInvokeLushangTypePostUploadFileMethodUrl:(NSString*)targetFullUrl
                                       andLocalFileData:(NSData*)targetLocalFileData
                                            andFileName:(NSString*)targetFileName
                                            andFileType:(NSString*)targetFileType
                                            andFileFrom:(NSString*)targetFileFrom
                                              andFileTo:(NSString*)targetFileTo
                                       andProgressBlock:(void (^)(float uploadProgress))progressBlock
                                         andSuccssBlock:(void (^)(id contextInfo))successBlock
                                           andFailBlock:(void (^)(NSError *error,id contextInfo))failBlock;










/**
 *  行车卫士的后台调用接口
 *
 *  @param targetFullUrl     完整的请求链接
 *  @param targetRequestInfo 请求的参数
 *  @param successBlock      成功需要执行的闭包
 *  @param failBlock         失败后需要执行的闭包
 */
- (void)cmcciotInvokeDriveGuardTypeApiWithFullPostMethodUrl:(NSString*)targetFullUrl
                                               andParams:(NSDictionary*)targetRequestInfo
                                         andSuccessBlock:(void (^)(id retValue))successBlock
                                            andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock;




@end

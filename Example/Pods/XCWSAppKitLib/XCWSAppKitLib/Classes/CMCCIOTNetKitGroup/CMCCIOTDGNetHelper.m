//
//  CMCCIOTDGNetHelper.m
//  driverGuard
//
//  Created by BigKrist on 16/3/21.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTDGNetHelper.h"
#import "CMCCIOTAppKit.h"

static CMCCIOTDGNetHelper *gDGNetHelper;

@implementation CMCCIOTDGNetHelper

+ (instancetype)shareInstance
{
    if(gDGNetHelper == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            gDGNetHelper = [[CMCCIOTDGNetHelper alloc] init];
        });
    }
    return gDGNetHelper;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)cmcciotDGPostParams:(NSDictionary *)targetParams successBlock:(void (^)(id))successBlock failBlock:(void (^)(NSError *, id))failBlock
{
    id appDel = [UIApplication sharedApplication].delegate;

    if(![appDel conformsToProtocol:@protocol(CMCCIOTAppKitDelegate)])
    {
        CMCCIOTLOG(@"没有实现获取基础地址的协议");
        return;
    }
    
    NSString *fullPostUrl = [((id<CMCCIOTAppKitDelegate>)appDel) cmcciotGetAppBaseServerUrl];
    [[CMCCIOTNetKit shareInstance] cmcciotInvokeApiWithFullPostMethodUrl:fullPostUrl andParams:targetParams andSuccessBlock:^(id retValue) {
        if(retValue == nil || ![retValue isKindOfClass:[NSDictionary class]] || [retValue objectForKey:@"result"] == nil)
        {
            NSError *errorInfo = [[NSError alloc] initWithDomain:@"返回数据异常" code:-1 userInfo:nil];
            if(failBlock != nil)
                failBlock(errorInfo,nil);
            return;
        }
        
        NSInteger resultIntValue = [[retValue objectForKey:@"result"] integerValue];
        if(resultIntValue != 0)
        {
            
            if(resultIntValue == 2)
            {
                NSString *tempCMD = [targetParams objectForKey:@"cmd"];
                
                //Session超时了的处理
                if(tempCMD != nil && ![tempCMD isStringEmpty] && ![tempCMD isEqualToString:@"tokenLogin"])
                {
                    //只有非tokenLogin的操作才暴会话过期，如果是tokenLogin实效，不处理，用自然错误处理。
                    dispatch_async(gMainQueueT, ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:gNoti_AppTokenWasExpierNoti object:retValue];
                    });
                    return;
                }
            }
            
            NSString *errorDes = @"服务器错误";
            if([retValue objectForKey:@"resultNote"] != nil)
                errorDes = [retValue objectForKey:@"resultNote"];
            
            NSError *errorInfo = [[NSError alloc] initWithDomain:errorDes code:-1 userInfo:nil];
            if(failBlock != nil)
                failBlock(errorInfo,nil);
            
            return;
        }
        
        NSDictionary *tempDetailInfo = [retValue objectForKey:@"detail"];
        if(tempDetailInfo == nil || ![tempDetailInfo isKindOfClass:[NSDictionary class]])
        {
            //detail数据不是匹配文档的数据
            NSError *errorInfo = [[NSError alloc] initWithDomain:@"返回数据异常" code:-1 userInfo:nil];
            if(failBlock != nil)
                failBlock(errorInfo,nil);
            return;
        }
        
        successBlock(tempDetailInfo);
    } andFailBlock:^(NSError *error, id contextInfo) {
        failBlock(error,contextInfo);
    }];
}

- (NSDictionary*)cmcciotDGCreatePostInfoWith:(NSString *)targetCMD params:(NSDictionary *)targetParams
{
    NSMutableDictionary *dicToRet = [[NSMutableDictionary alloc] init];
    [dicToRet setValue:targetCMD forKey:@"cmd"];
    NSMutableDictionary *paramsDicContainer = nil;
    if(targetParams != nil)
        paramsDicContainer = [[NSMutableDictionary alloc] initWithDictionary:targetParams];
    else
        paramsDicContainer = [[NSMutableDictionary alloc] init];
    
    
    //添加token
//    CMCCIOTUserDataModel *nowLoginUser = [[CMCCIOTGlobalUserDataManager shareInstance] cmcciotGetNowLoginUser];
//    if(nowLoginUser != nil && nowLoginUser.token != nil)
//        [dicToRet setObject:nowLoginUser.token forKey:@"token"];
    
    
    [dicToRet setObject:paramsDicContainer forKey:@"params"];
    
    
    return dicToRet;
}

@end

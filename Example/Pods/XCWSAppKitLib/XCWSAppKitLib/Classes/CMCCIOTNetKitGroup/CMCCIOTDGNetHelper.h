//
//  CMCCIOTDGNetHelper.h
//  driverGuard
//  网络调用基础处理类
//  Created by BigKrist on 16/3/21.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCCIOTDGNetHelper : NSObject
+ (instancetype)shareInstance;
- (void)cmcciotDGPostParams:(NSDictionary*)targetParams
               successBlock:(void (^)(id retValue))successBlock
                  failBlock:(void (^)(NSError *error, id contextInfo))failBlock;

- (NSDictionary*)cmcciotDGCreatePostInfoWith:(NSString*)targetCMD params:(NSDictionary*)targetParams;
@end

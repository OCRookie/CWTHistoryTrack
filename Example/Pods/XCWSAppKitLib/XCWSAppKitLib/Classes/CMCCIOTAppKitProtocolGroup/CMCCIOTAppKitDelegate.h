//
//  CMCCIOTAppKitDelegate.h
//  CMCCIOTAppKit
//  CMCCIOTAppKit基本协议文件，一些必须要使用这个AppKit的App的delegate文件去实现该协议
//  Created by BigKrist on 15/4/20.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMCCIOTAppKitDelegate <NSObject>

/**
 *  提供App的Key
 *
 *  @return 自己App的Key
 */
- (NSString*)cmcciotGetAppKey;

/**
 *  提供App的secretkey
 *
 *  @return 自己App的SecretKey
 */
- (NSString*)cmcciotGetAppSecrectKey;


/**
 *  提供App对服务器进行请求的时候的基础服务器地址
 *
 *  @return 返回本App对服务器请求的基础服务器地址
 */
- (NSString*)cmcciotGetAppBaseServerUrl;
@end

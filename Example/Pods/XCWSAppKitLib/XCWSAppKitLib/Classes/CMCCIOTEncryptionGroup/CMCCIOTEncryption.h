//
//  CMCCIOTEncryption.h
//  CMCCIOTAppKit
//  部分AES加密解密函数和编码函数
//  Created by BigKrist on 15/4/20.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCCIOTEncryption : NSObject

@end


@interface NSData (CMCCIOTEncryption)
/**
 *  将NSData进行AES256加密的方法
 *
 *  @param key AES256加密的密钥
 *
 *  @return 返回加密后的NSData数据, 加密失败的话返回nil
 */
- (NSData *)cmcciotAES256EncryptWithKey:(NSString *)key;

/**
 *  将AES256加密之后的NSData数据进行解密的方法
 *
 *  @param key 进行AES256解密的密钥
 *
 *  @return 返回解密后的NSData数据, 解密失败的话返回nil
 */
- (NSData *)cmcciotAES256DecryptWithKey:(NSString *)key;

- (NSString *)cmcciotNewStringInBase64FromData;            //追加64编码
+ (NSString*)cmcciotBase64encode:(NSString*)str;           //同上64编码


+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;
@end
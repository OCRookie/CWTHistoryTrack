//
//  NSString+CMCCIOTFundationCategory.h
//  CMCCIOTAppKit
//  NSString的一些常用扩展
//  Created by BigKrist on 15/4/22.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+ColorCategory.h"

@interface NSString (CMCCIOTFundationCategory)

/**
 *  返回本地化字符串
 *
 *  @return 返回指定字符串的本地化字符串
 */
- (NSString*)cmcciotLocalizedString;


/**
 *  将字符串按照指定的格式进行NSDate反转
 *
 *  @param targetTimeStyle 指定的格式
 *
 *  @return 匹配的NSDate类型
 */
- (NSDate*)cmcciotDateWithTimeStyle:(NSString*)targetTimeStyle;

/**
 *  返回yyyy-MM-dd HH:mm:ss所匹配的NSDate类型数据
 *
 *  @return 匹配的NSDate数据
 */
- (NSDate*)cmcciotYYYYMMDDHHMMSSDate;


/**
 *  返回yyyy-MM-dd HH:mm所匹配的NSDate类型数据
 *
 *  @return 匹配的NSDate数据
 */
- (NSDate*)cmcciotYYYYMMDDHHMMDate;


/**
 *  返回yyyy-MM-dd所匹配的NSDate类型数据
 *
 *  @return 匹配的NSDate数据
 */
- (NSDate*)cmcciotYYYYMMDDDate;


/**
 *  返回本字符串的Url编码的字符串
 *
 *  @return 本字符串的url编码字符串
 */
- (NSString*)cmcciotURLEncodedString;


/**
 *  返回本字符串的URL反编码之后的字符串
 *
 *  @return URL反编码之后的字符串
 */
- (NSString*)cmcciotURLDecodedString;



/**
 *  返回本字符串的MD5编码字符串
 *
 *  @return 本字符串Md5编码后的结果
 */
- (NSString*)cmcciotMD5String;

/**
 *  返回本字符串去处空格之后的字符串
 *
 *  @return 本字符串去空格之后的结果
 */
- (NSString*)cmcciotPureString;


/**
 *  生成一个UUID
 *
 *  @return 生成的唯一的UUID
 */
+ (NSString*)cmcciotGenUUID;

/**
 *  16进制字符串，转换成对应的二进制字符串。例NSString = @"F", 返回@“1111”。 NSString = @"63", 返回@“0110 0011”
 *
 *  @return 生成对应的二进制字符串
 */
- (NSString*)binaryRepresentation;
@end

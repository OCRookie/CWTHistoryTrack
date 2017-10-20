//
//  NSString+CMCCIOTFundationCategory.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/22.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "NSString+CMCCIOTFundationCategory.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (CMCCIOTFundationCategory)
- (NSString*)cmcciotLocalizedString
{
    return NSLocalizedString(self, @"");
}

/**
 *  将字符串按照指定的格式进行NSDate反转
 *
 *  @param targetTimeStyle 指定的格式
 *
 *  @return 匹配的NSDate类型
 */
- (NSDate*)cmcciotDateWithTimeStyle:(NSString*)targetTimeStyle
{
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:targetTimeStyle];
        NSDate *retDate = [dateFormatter dateFromString:self];
        return retDate;
    }
    @catch (NSException *exception) {
        return [NSDate date];
    }
}

/**
 *  返回yyyy-MM-dd HH:mm:ss所匹配的NSDate类型数据
 *
 *  @return 匹配的NSDate数据
 */
- (NSDate*)cmcciotYYYYMMDDHHMMSSDate
{
    return [self cmcciotDateWithTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
}


/**
 *  返回yyyy-MM-dd HH:mm所匹配的NSDate类型数据
 *
 *  @return 匹配的NSDate数据
 */
- (NSDate*)cmcciotYYYYMMDDHHMMDate
{
    return [self cmcciotDateWithTimeStyle:@"yyyy-MM-dd HH:mm"];
}


/**
 *  返回yyyy-MM-dd所匹配的NSDate类型数据
 *
 *  @return 匹配的NSDate数据
 */
- (NSDate*)cmcciotYYYYMMDDDate
{
    return [self cmcciotDateWithTimeStyle:@"yyyy-MM-dd"];
}




/**
 *  返回本字符串的Url编码的字符串
 *
 *  @return 本字符串的url编码字符串
 */
- (NSString*)cmcciotURLEncodedString
{
//    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef)self,
//                                                              NULL,
//                                                              CFSTR("!$&'()*+,-./:;=?@_~%#[]"),    //!*'();:@&amp;=+$,/?%#[] 以前老的过滤符号是这个，有错
//                                                              kCFStringEncodingUTF8));
//    return result;
    
    
    NSString *newString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return @"";
}


/**
 *  返回本字符串的URL反编码之后的字符串
 *
 *  @return URL反编码之后的字符串
 */
- (NSString*)cmcciotURLDecodedString
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                              (CFStringRef)self,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return result;
}


/**
 *  返回本字符串的MD5编码字符串
 *
 *  @return 本字符串Md5编码后的结果
 */
- (NSString*)cmcciotMD5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



+ (NSString*)cmcciotGenUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}

- (NSString*)cmcciotPureString
{
    NSString *retString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return retString;
}

/**
 *  16进制字符串，转换成对应的二进制字符串
 *
 *  @return 16进制字符串，转换成对应的二进制字符串
 */
- (NSString*)binaryRepresentation
{
    NSString *binaryString;
    unsigned int numberofdigits = (unsigned int)self.length*4;
    unsigned long ab = strtoul([self UTF8String], 0, 16);
    binaryString = [self binaryStringRepresentationOfInt:ab numberOfDigits:numberofdigits];
    return binaryString;
}

- (NSString *)binaryStringRepresentationOfInt:(long)value numberOfDigits:(unsigned int)numberOfDigits
{
    const unsigned int chunkLength = 4;
    //  unsigned int numberOfDigits = 8;
    NSMutableString *string = [NSMutableString new];
    
    for(int i = 0; i < numberOfDigits; i ++) {
        NSString *divider = i % chunkLength == chunkLength-1 ? @" " : @"";
        NSString *part = [NSString stringWithFormat:@"%@%i", divider, value & (1 << i) ? 1 : 0]; // 1<<i 表示把1左移i位，每次左移就是乘以2； 按位与&，只有对应的两个二进位均为1时，结果位才为1，否则为0。比如9&5，其实就是1001&101=1，因此9&5=1
        [string insertString:part atIndex:0];
    }
    
    return string;
}

@end

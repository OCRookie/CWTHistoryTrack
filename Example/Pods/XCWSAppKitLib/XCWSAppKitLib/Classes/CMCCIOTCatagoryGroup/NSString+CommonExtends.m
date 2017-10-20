//
//  NSString+CommonExtends.m
//  XiaoDao
//
//  Created by BigKrist on 15/12/7.
//  Copyright © 2015年 CMCCIOT. All rights reserved.
//

#import "NSString+CommonExtends.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CommonExtends)

//判断字符串是否为空
- (BOOL)isStringEmpty
{
    if(self && ![self isEqual:[NSNull null]] && ![self isEqualToString:@""] && ![[self stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && self != nil){
        return NO;
    }else{
        return YES;
    }
}

//过滤“ ”空格后判断是否为空
- (BOOL)isStringEmptyOrBlank
{
    if([self isStringEmpty] || [@"" isEqualToString:[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        return YES;
    }else{
        return NO;
    }
}

/*正则表达式匹配*/
-(BOOL)matchRegExp:(NSString *)regex{
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phoneTest evaluateWithObject:self];
}
/*手机号码验证*/
-(BOOL)validateMobile{
    //手机号以第一位是1，第二位“3-8” 加上 9个数字
    return [self matchRegExp:@"^[1][0-9]\\d{9}"];
}
/*车牌号验证*/
-(BOOL)validateLicensePlateNo{
    return [self matchRegExp:@"^[\u4e00-\u9fa5]{1}[A-Za-z]{1}[A-Za-z_0-9]{5}$"];
}
/*Email地址验证*/
-(BOOL)validateEmail{
    return [self matchRegExp:@"\\w+([-+\\.]\\w+)*@\\w+([-\\.]\\w+)*\\.\\w+([-\\.]\\w+)*"];
}
/*URL地址验证*/
-(BOOL)validateURL{
    return [self matchRegExp:@"[a-zA-z]+://[^\\s]*"];
}
/*邮政编码验证*/
-(BOOL)validateZipCode{
    return [self matchRegExp:@"[1-9]\\d{5}(?!\\d)"];
}
/*帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)*/
-(BOOL)validateAccountNo{
    return [self matchRegExp:@"^[a-zA-Z][a-zA-Z0-9_]{4,15}$"];
}
/*国内电话号码验证*/
-(BOOL)validatePhoneNo{
    return [self matchRegExp:@"\\d{3}-\\d{8}|\\d{4}-\\d{7}"];
}
/*腾讯QQ号验证(腾讯QQ号从10000开始)*/
-(BOOL)validateTencentQQ{
    return [self matchRegExp:@"[1-9][0-9]{4,}"];
}
/*身份证验证*/
-(BOOL)validateIDCard{
    return [self matchRegExp:@"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$"] || [self matchRegExp:@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])(\\d{4}|\\d{3}(\\d|X|x))$"];
}
/*ip地址验证*/
-(BOOL)validateIPAddress{
    return [self matchRegExp:@"\\d+\\.\\d+\\.\\d+\\.\\d+"];
}
/*n位英文字母组成的字符串*/
-(BOOL)validateLetter:(int)n{
    NSString *regex = n <= 0?@"^[A-Za-z]+$":[NSString stringWithFormat:@"^[A-Za-z]{%d}$",n];
    return [self matchRegExp:regex];
}
/*n位大写英文字母组成的字符串*/
-(BOOL)validateUppercaseLetter:(int)n{
    NSString *regex = n <= 0?@"^[A-Z]+$":[NSString stringWithFormat:@"^[A-Z]{%d}$",n];
    return [self matchRegExp:regex];
}
/*n位小写英文字母组成的字符串*/
-(BOOL)validateLowercaseLetter:(int)n{
    NSString *regex = n <= 0?@"^[a-z]+$":[NSString stringWithFormat:@"^[a-z]{%d}$",n];
    return [self matchRegExp:regex];
}
/*密码验证（以字母开头，长度在6-18之间，只能包含字符、数字和下划线）*/
-(BOOL)validatePassword{
    return [self matchRegExp:@"^[a-zA-Z]w{5,17}$"];
}

/*VIN验证*/
-(BOOL)validateVIN{
    return [self matchRegExp:@"^[A-Za-z0-9]{17}"];
}

/* 里程字段验证 (该字段必须为数字、正数、且不能为空) */
- (BOOL)validateNotNullPositiveInteger {
    if ([self isStringEmpty]) {
        return false;
    }
    return [self matchRegExp:@"^\\d+$"];
}

/*String 转 NSDate*/
-(NSDate *) stringDateWithFormat:(NSString *) format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = format;
    return [formatter dateFromString:self];
}

/*只能由汉字、字母、数字、下划线组成*/
- (BOOL)validateUserName{
    return [self matchRegExp:@"\\w+"];
}
@end

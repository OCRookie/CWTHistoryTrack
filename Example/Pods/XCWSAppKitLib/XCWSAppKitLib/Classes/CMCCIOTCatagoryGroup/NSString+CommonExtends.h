//
//  NSString+CommonExtends.h
//  XiaoDao
//
//  Created by BigKrist on 15/12/7.
//  Copyright © 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CommonExtends)
//判断字符串是否为空
- (BOOL)isStringEmpty;
//过滤“ ”空格后判断是否为空
- (BOOL)isStringEmptyOrBlank;

/*正则表达式匹配*/
-(BOOL)matchRegExp:(NSString *)regex;
/*手机号码验证*/
-(BOOL)validateMobile;
/*车牌号验证*/
-(BOOL)validateLicensePlateNo;
/*Email地址验证*/
-(BOOL)validateEmail;
/*URL地址验证*/
-(BOOL)validateURL;
/*邮政编码验证*/
-(BOOL)validateZipCode;
/*帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)*/
-(BOOL)validateAccountNo;
/*国内电话号码验证*/
-(BOOL)validatePhoneNo;
/*腾讯QQ号验证(腾讯QQ号从10000开始)*/
-(BOOL)validateTencentQQ;
/*身份证验证*/
-(BOOL)validateIDCard;
/*ip地址验证*/
-(BOOL)validateIPAddress;
/*n位英文字母组成的字符串*/
-(BOOL)validateLetter:(int)n;
/*n位大写英文字母组成的字符串*/
-(BOOL)validateUppercaseLetter:(int)n;
/*n位小写英文字母组成的字符串*/
-(BOOL)validateLowercaseLetter:(int)n;
/*密码验证（以字母开头，长度在6-18之间，只能包含字符、数字和下划线）*/
-(BOOL)validatePassword;
/*车架号校验 17位数字字母*/
-(BOOL)validateVIN;
/* 里程字段验证 (该字段必须为数字、正数、且不能为空) */
-(BOOL)validateNotNullPositiveInteger;
/*String 转 NSDate*/
-(NSDate *) stringDateWithFormat:(NSString *) format;
/*只能由汉字、字母、数字、下划线组成*/
- (BOOL)validateUserName;
@end

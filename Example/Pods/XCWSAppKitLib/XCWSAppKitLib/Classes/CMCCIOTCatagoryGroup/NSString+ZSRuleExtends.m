//
//  NSString+ZSRuleExtends.m
//  zongshenMotor
//
//  Created by gaomaolin on 16/2/15.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "NSString+ZSRuleExtends.h"
#import "NSString+CommonExtends.h"

@implementation NSString (ZSRuleExtends)
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)cmcciotValidScanBatteryCode
{
    NSPredicate *batteryCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[0-9a-zA-Z]{6}-[0-9]{6}"];
    return [batteryCodePredicate evaluateWithObject:self];
}

- (BOOL)cmcciotValidZSUserNickName
{
    //判断是否合理的宗申用户昵称 （只能包含中文字符串，大小写字母，数字和下划线）
    if(self == nil || [self isStringEmpty]) return NO;
    if(self.length <= 0) return NO;
    if(self.length > 10) return NO;    //长度介于1～10之间
    NSArray *commonSet = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"_"];
    for(NSInteger index = 0; index < self.length; index++)
    {
        unichar opChar = [self characterAtIndex:index];
        if(opChar >= 0x4e00 && opChar <= 0x9fff)   //这个字符是中文
        {
            
        }
        else
        {
            NSString *tempStr = [NSString stringWithCharacters:&opChar length:1];
            if(![commonSet containsObject:tempStr])
                return NO;
        }
    }
    return YES;
}

- (BOOL)cmcciotValidVerifyCode
{
    NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[0-9]{4}"];
    return [verifyCodePredicate evaluateWithObject:self];
}

- (BOOL)cmcciotValidDeviceNum
{
    //验证是否有效的设备序列号
    //固定的16位数字
    NSPredicate *deviceNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[0-9]{16}"];
    return [deviceNumPredicate evaluateWithObject:self];
}

- (BOOL)cmcciotValidMotorVin
{
    // 验证是否有效的设备Vin号
    //不超过20个字符,只能含有数字、字母、短横线、下划线，不区分大小写
    if(self == nil || [self isStringEmpty]) return NO;
    if(self.length <= 0) return NO;
    if(self.length > 20) return NO;
    NSArray *commonSet = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"_",@"-"];
    for(NSInteger index = 0; index < self.length; index++)
    {
        unichar opChar = [self characterAtIndex:index];
        
        NSString *tempStr = [NSString stringWithCharacters:&opChar length:1];
        if(![commonSet containsObject:tempStr])
            return NO;
    }
    return YES;
}

- (BOOL)cmcciotValidZSPsw
{
    //判断是否合理的宗申密码 (只能包含大小写字母，数字和下划线)
    if(self == nil || [self isStringEmpty]) return NO;
    NSArray *commonCharSet = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    
    NSArray *commonNumberSet = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    
    NSArray *otherSet = @[@"_"];
    BOOL hasChar = NO;
    BOOL hasNumber = NO;
    BOOL hasOther = NO;
    for(NSInteger index = 0; index < self.length; index++)
    {
        unichar opChar = [self characterAtIndex:index];
        
        NSString *tempStr = [NSString stringWithCharacters:&opChar length:1];
        
        if ([commonCharSet containsObject:tempStr]) {
            hasChar = YES;
        } else if ([commonNumberSet containsObject:tempStr]) {
            hasNumber = YES;
        } else if ([otherSet containsObject:tempStr]) {
            hasOther = YES;
        } else {
            //包含数字，字母、下划线之外的字符，则不符合规则
            return NO;
        }
    }
    return YES;
    /* 必须包含数字、字母 */
    /*
    if (hasChar && hasNumber) {
        return YES;
    } else {
        return NO;
    }
    */
}

@end

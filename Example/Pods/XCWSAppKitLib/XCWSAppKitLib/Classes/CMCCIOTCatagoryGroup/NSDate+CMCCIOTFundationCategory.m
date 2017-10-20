//
//  NSDate+CMCCIOTFundationCategory.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/22.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "NSDate+CMCCIOTFundationCategory.h"

@implementation NSDate (CMCCIOTFundationCategory)

- (NSString*)cmcciotFormatDateStyle:(NSString *)targetTimeStyle
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:targetTimeStyle];
    NSString *retString = [dateFormatter stringFromDate:self];
    return retString;
}

/**
 *  返回yyyy-MM-dd HH:mm:ss格式的时间字符串
 *
 *  @return yyyy-MM-dd HH:mm:ss格式的时间字符串
 */
- (NSString*)cmcciotYYYYMMDDHHMMSS
{
    return [self cmcciotFormatDateStyle:@"yyyy-MM-dd HH:mm:ss"];
}


/**
 *  返回yyyy-MM-dd HH:mm格式的时间字符串
 *
 *  @return yyyy-MM-dd HH:mm格式的时间字符串
 */
- (NSString*)cmcciotYYYYMMDDHHMM
{
    return [self cmcciotFormatDateStyle:@"yyyy-MM-dd HH:mm"];
}


/**
 *  返回yyyy-MM-dd格式的时间字符串
 *
 *  @return yyyy-MM-dd格式的时间字符串
 */
- (NSString*)cmcciotYYYYMMDD
{
    return [self cmcciotFormatDateStyle:@"yyyy-MM-dd"];
}


/**
 *  返回yyyy-MM格式的时间字符串
 *
 *  @return yyyy-MM格式的时间字符串
 */
- (NSString*)cmcciotYYYYMM
{
    return [self cmcciotFormatDateStyle:@"yyyy-MM"];
}



/**
 *  返回MM-dd格式的时间字符串
 *
 *  @return MM-dd格式的时间字符串
 */
- (NSString*)cmcciotMMDD
{
    return [self cmcciotFormatDateStyle:@"MM-dd"];
}


/**
 *  返回MM-dd HH:mm格式的时间字符串
 *
 *  @return MM-dd HH:mm格式的时间字符串
 */
- (NSString*)cmcciotMMDDHHMM
{
    return [self cmcciotFormatDateStyle:@"MM-dd HH:mm"];
}


/**
 *  返回HH:mm格式的时间字符串
 *
 *  @return HH:mm格式的时间字符串
 */
- (NSString*)cmcciotHHMM
{
    return [self cmcciotFormatDateStyle:@"HH:mm"];
}


/**
 *  返回HH:mm:ss格式的时间字符串
 *
 *  @return HH:mm:ss格式的时间字符串
 */
- (NSString*)cmcciotHHMMSS
{
    return [self cmcciotFormatDateStyle:@"HH:mm:ss"];
}


- (NSString*)cmcciotWeekDay
{
    NSDateComponents *dateCompoents = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    NSInteger weekDayInt = [dateCompoents weekday];
    switch (weekDayInt) {
        case 1:
            return @"周日";
        case 2:
            return @"周一";
        case 3:
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 7:
            return @"周六";
            
        default:
            break;
    }
    return @"";
}

@end

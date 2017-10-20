//
//  NSDate+CMCCIOTFundationCategory.h
//  CMCCIOTAppKit
//  扩展NSDate类，方便返回各种格式时间字符串
//  Created by BigKrist on 15/4/22.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CMCCIOTFundationCategory)

/**
 *  返回指定有效格式的时间字符串
 *
 *  @param targetTimeStyle 要转换为的时间格式字符串
 *
 *  @return 有效的指定格式的时间字符串
 */
- (NSString*)cmcciotFormatDateStyle:(NSString*)targetTimeStyle;

/**
 *  返回yyyy-MM-dd HH:mm:ss格式的时间字符串
 *
 *  @return yyyy-MM-dd HH:mm:ss格式的时间字符串
 */
- (NSString*)cmcciotYYYYMMDDHHMMSS;


/**
 *  返回yyyy-MM-dd HH:mm格式的时间字符串
 *
 *  @return yyyy-MM-dd HH:mm格式的时间字符串
 */
- (NSString*)cmcciotYYYYMMDDHHMM;


/**
 *  返回yyyy-MM-dd格式的时间字符串
 *
 *  @return yyyy-MM-dd格式的时间字符串
 */
- (NSString*)cmcciotYYYYMMDD;


/**
 *  返回yyyy-MM格式的时间字符串
 *
 *  @return yyyy-MM格式的时间字符串
 */
- (NSString*)cmcciotYYYYMM;



/**
 *  返回MM-dd格式的时间字符串
 *
 *  @return MM-dd格式的时间字符串
 */
- (NSString*)cmcciotMMDD;


/**
 *  返回MM-dd HH:mm格式的时间字符串
 *
 *  @return MM-dd HH:mm格式的时间字符串
 */
- (NSString*)cmcciotMMDDHHMM;


/**
 *  返回HH:mm格式的时间字符串
 *
 *  @return HH:mm格式的时间字符串
 */
- (NSString*)cmcciotHHMM;


/**
 *  返回HH:mm:ss格式的时间字符串
 *
 *  @return HH:mm:ss格式的时间字符串
 */
- (NSString*)cmcciotHHMMSS;

/**
 *  返回星期的数据
 *
 *  @return 周一，周二，周三
 */
- (NSString*)cmcciotWeekDay;

@end

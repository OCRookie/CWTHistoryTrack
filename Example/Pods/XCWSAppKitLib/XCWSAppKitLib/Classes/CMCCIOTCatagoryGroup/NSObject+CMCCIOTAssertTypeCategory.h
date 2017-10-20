//
//  NSObject+CMCCIOTAssertTypeCategory.h
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/5/28.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CMCCIOTAssertTypeCategory)
/**
 *  NSObjectde一个自定义扩展，快速判断是否是NSDictionary类型的对象
 *
 *  @return YES：表示是NSDictionary类型对象 NO: 表示不是NSDictionary类型对象
 */
- (BOOL)isNSDictionaryType;


/**
 *  NSObjectde一个自定义扩展，快速判断是否是NSArray类型的对象
 *
 *  @return YES：表示是NSArray类型对象 NO: 表示不是NSArray类型对象
 */
- (BOOL)isNSArrayType;
@end

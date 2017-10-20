//
//  NSObject+CMCCIOTAssertTypeCategory.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/5/28.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "NSObject+CMCCIOTAssertTypeCategory.h"

@implementation NSObject (CMCCIOTAssertTypeCategory)

- (BOOL)isNSDictionaryType
{
    if(self == nil) return NO;
    if([self isKindOfClass:[NSDictionary class]])
        return YES;
    return NO;
}

- (BOOL)isNSArrayType
{
    if(self == nil) return NO;
    if([self isKindOfClass:[NSArray class]])
        return YES;
    return NO;
}


@end

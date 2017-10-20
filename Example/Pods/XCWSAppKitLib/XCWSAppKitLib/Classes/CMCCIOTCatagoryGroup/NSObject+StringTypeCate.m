//
//  NSObject+StringTypeCate.m
//  LuShang
//
//  Created by BigKrist on 16/10/11.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "NSObject+StringTypeCate.h"

@implementation  NSObject (StringTypeCate)
- (BOOL)isValidNonNilStringType
{
    if(self == nil) return NO;
    if(![self isKindOfClass:[NSString class]])
        return NO;
    
    NSString *targetStr = (NSString*)self;
    NSString *newStr = [targetStr stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, targetStr.length)];
    if([newStr isEqualToString:@""])
        return NO;
    
    return YES;
}
@end

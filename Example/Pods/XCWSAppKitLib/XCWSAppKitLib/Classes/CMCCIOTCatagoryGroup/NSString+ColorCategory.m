//
//  NSString+ColorCategory.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/21.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "NSString+ColorCategory.h"

@implementation NSString (CMCCIOTColorCategory)
- (UIColor*)cmcciotHexColor
{
    return [self cmcciotHexColorWithAlpha:1];
}

- (UIColor*)cmcciotHexColorWithAlpha:(CGFloat)targetFloat
{
    NSString *converStr = self;
    if([converStr hasPrefix:@"#"])
        converStr = [converStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    UIColor *colorToReturn = nil;
    @try {
        NSString *rs = [converStr substringWithRange:NSMakeRange(0, 2)];
        long r = strtol([rs UTF8String],NULL, 16);
        NSString *gs = [converStr substringWithRange:NSMakeRange(2, 2)];
        long g = strtol([gs UTF8String],NULL, 16);
        NSString *bs = [converStr substringWithRange:NSMakeRange(4, 2)];
        long b = strtol([bs UTF8String],NULL, 16);
        
        colorToReturn = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:targetFloat];
    }
    @catch (NSException *exception) {
        colorToReturn = nil;
    }
    return colorToReturn;
}

- (UIColor*)cmcciotHexARGBColor
{
    NSString *converStr = self;
    if([converStr hasPrefix:@"#"])
        converStr = [converStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    UIColor *colorToReturn = nil;
    @try {
        NSString *as = [converStr substringWithRange:NSMakeRange(0, 2)];
        long a = strtol([as UTF8String], NULL, 16);
        NSString *rs = [converStr substringWithRange:NSMakeRange(2, 2)];
        long r = strtol([rs UTF8String],NULL, 16);
        NSString *gs = [converStr substringWithRange:NSMakeRange(4, 2)];
        long g = strtol([gs UTF8String],NULL, 16);
        NSString *bs = [converStr substringWithRange:NSMakeRange(6, 2)];
        long b = strtol([bs UTF8String],NULL, 16);
        
        colorToReturn = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
    }
    @catch (NSException *exception) {
        colorToReturn = nil;
    }
    return colorToReturn;
}

@end

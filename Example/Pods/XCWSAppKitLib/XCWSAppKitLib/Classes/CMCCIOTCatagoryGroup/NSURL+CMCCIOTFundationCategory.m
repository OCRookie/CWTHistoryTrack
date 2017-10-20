//
//  NSURL+CMCCIOTFundationCategory.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/7/15.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "NSURL+CMCCIOTFundationCategory.h"

@implementation NSURL (CMCCIOTFundationCategory)
- (NSDictionary*)cmcciotQueryStringDicts
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self.query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}
@end

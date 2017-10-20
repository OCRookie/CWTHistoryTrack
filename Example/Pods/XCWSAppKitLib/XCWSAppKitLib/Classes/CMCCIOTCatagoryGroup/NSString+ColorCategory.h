//
//  NSString+ColorCategory.h
//  CMCCIOTAppKit
//  字符串的一个颜色扩展
//  Created by BigKrist on 15/4/21.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CMCCIOTColorCategory)
- (UIColor*)cmcciotHexColor;
- (UIColor*)cmcciotHexColorWithAlpha:(CGFloat)targetFloat;
- (UIColor*)cmcciotHexARGBColor;
@end

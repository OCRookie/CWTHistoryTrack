//
//  UIView+CMCCIOTCategory.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/21.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "UIView+CMCCIOTCategory.h"

@implementation UIView (CMCCIOTCategory)
- (UIImage*)cmcciotImage
{
    CGSize size = self.bounds.size;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    size.width *= scale;
    size.height *= scale;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(ctx, scale, scale);
    
    [self.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

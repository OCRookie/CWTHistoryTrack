//
//  UIImage+Oxygen.h
//  
//
//  Created by zhang cheng on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Oxygen)

//color 转 image size(1,1)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
//从bundle中读取image
//+ (UIImage *)imageNamed:(NSString *)name bundle:(NSString *)bundleName;
//从Oxygen类库中读取Image
//+ (UIImage *)ofImageNamed:(NSString *)name;

//Image缩放 利用drawInRect的方式，缩放效果比下面的方法好一些
- (UIImage *)scaledToSize:(CGSize)newSize;
//Image缩放 缩小时有锯齿
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end

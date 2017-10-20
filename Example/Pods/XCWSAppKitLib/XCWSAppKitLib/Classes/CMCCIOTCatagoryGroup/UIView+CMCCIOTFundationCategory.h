//
//  UIView+CMCCIOTFundationCategory.h
//  CMCCIOTAppKit
//  部分UIView方法扩展
//  Created by BigKrist on 15/4/22.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+CMCCIOTCategory.h"
#import <UIKit/UIKit.h>

@interface UIView (CMCCIOTFundationCategory)

/**
 *  UIView在superView的originX
 *
 *  @return UIView的originX
 */
- (CGFloat)cmcciotBegingX;


/**
 *  UIView在superView的originY
 *
 *  @return UIView的originY
 */
- (CGFloat)cmcciotBegingY;


/**
 *  UIView在superView的originX + width
 *
 *  @return UIView的结束x坐标
 */
- (CGFloat)cmcciotEndX;


/**
 *  UIView在superView的originY + height
 *
 *  @return UIView的结束y坐标
 */
- (CGFloat)cmcciotEndY;



/**
 *  和指定的UIView在x方向上的距离, 仅限于在同一superview上的两个视图，否则返回0
 *
 *  @param targetView 指定的UIView
 *
 *  @return x方向的间隔距离值
 */
- (CGFloat)cmcciotOffsetXFrom:(UIView*)targetView;


/**
 *  和指定的UIView在y方向上的距离, 仅限于在同一superview上的两个视图，否则返回0
 *
 *  @param targetView 指定的UIView
 *
 *  @return y方向的间隔距离值
 */
- (CGFloat)cmcciotOffsetYFrom:(UIView*)targetView;

@end

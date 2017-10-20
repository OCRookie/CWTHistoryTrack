//
//  UIView+CMCCIOTFundationCategory.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/22.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "UIView+CMCCIOTFundationCategory.h"

@implementation UIView (CMCCIOTFundationCategory)



/**
 *  UIView在superView的originX
 *
 *  @return UIView的originX
 */
- (CGFloat)cmcciotBegingX
{
    return self.frame.origin.x;
}


/**
 *  UIView在superView的originY
 *
 *  @return UIView的originY
 */
- (CGFloat)cmcciotBegingY
{
    return self.frame.origin.y;
}


/**
 *  UIView在superView的originX + width
 *
 *  @return UIView的结束x坐标
 */
- (CGFloat)cmcciotEndX
{
    return self.frame.origin.x + self.frame.size.width;
}


/**
 *  UIView在superView的originY + height
 *
 *  @return UIView的结束y坐标
 */
- (CGFloat)cmcciotEndY
{
    return self.frame.origin.y + self.frame.size.height;
}



/**
 *  和指定的UIView在x方向上的距离
 *
 *  @param targetView 指定的UIView
 *
 *  @return x方向的间隔距离值
 */
- (CGFloat)cmcciotOffsetXFrom:(UIView*)targetView
{
    if(targetView == nil) return 0;
    if(self.superview == nil || targetView.superview == nil) return 0;
    if(self.superview != targetView.superview) return 0;
    return ([self cmcciotBegingX] - [targetView cmcciotEndX]);
}


/**
 *  和指定的UIView在y方向上的距离
 *
 *  @param targetView 指定的UIView
 *
 *  @return y方向的间隔距离值
 */
- (CGFloat)cmcciotOffsetYFrom:(UIView*)targetView
{
    if(targetView == nil) return 0;
    if(self.superview == nil || targetView.superview == nil) return 0;
    if(self.superview != targetView.superview) return 0;
    return ([self cmcciotBegingY] - [targetView cmcciotEndY]);
}

@end

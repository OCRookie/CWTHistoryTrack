//
//  CMCCIOTZSSelectTrackTimeBtn.m
//  zongshenMotor
//
//  Created by BigKrist on 16/2/24.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTZSSelectTrackTimeBtn.h"
#import "CMCCIOTAppKit.h"

@interface CMCCIOTZSSelectTrackTimeBtn ()
{
    UIView *leftView;
    UIView *rightView;
    UILabel *leftTextLabel;
    UILabel *rightTextLabel;
}
- (void)createCustomView;
@end

@implementation CMCCIOTZSSelectTrackTimeBtn


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createCustomView];
    }
    return self;
}


- (void)createCustomView
{
    self.backgroundColor = [UIColor clearColor];
    
    leftView = [[UIView alloc] init];
    [self addSubview:leftView];
    leftView.keepLeftInset.equal = 0;
    leftView.keepWidth.equal = 35;
    leftView.keepTopInset.equal = 0;
    leftView.keepBottomInset.equal = 0;
    leftView.keepVerticalCenter.equal = 0.5;
    leftView.userInteractionEnabled = NO;
    
    leftTextLabel = [[UILabel alloc] init];
    [leftView addSubview:leftTextLabel];
    leftTextLabel.keepInsets.equal = 0;
    leftTextLabel.font = [UIFont boldSystemFontOfSize:17];
    leftTextLabel.backgroundColor = [UIColor clearColor];
    leftTextLabel.textAlignment = NSTextAlignmentCenter;
    leftTextLabel.textColor = [UIColor whiteColor];
    leftTextLabel.userInteractionEnabled = NO;
    
    rightView = [[UIView alloc] init];
    [self addSubview:rightView];
    rightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    rightView.keepLeftOffsetTo(leftView).equal = 0;
    rightView.keepRightInset.equal = 0;
    rightView.keepTopInset.equal = 0;
    rightView.keepBottomInset.equal = 0;
    rightView.keepVerticalCenter.equal = 0.5;
    rightView.userInteractionEnabled = NO;
    
    rightTextLabel = [[UILabel alloc] init];
    [rightView addSubview:rightTextLabel];
    rightTextLabel.keepInsets.equal = 0;
    rightTextLabel.font = [UIFont boldSystemFontOfSize:17];
    rightTextLabel.backgroundColor = [UIColor clearColor];
    rightTextLabel.textAlignment = NSTextAlignmentCenter;
    rightTextLabel.textColor = [UIColor whiteColor];
    rightTextLabel.userInteractionEnabled = NO;
}

- (void)cmcciotZSSetLeftViewColor:(UIColor*)targetColor
{
    leftView.backgroundColor = targetColor;
}

- (void)cmcciotZSSetLeftViewText:(NSString*)targetText
{
    leftTextLabel.text = targetText;
}

- (void)cmcciotZSSetRightViewText:(NSString*)targetText
{
    rightTextLabel.text = targetText;
}

- (NSString*)cmcciotZSGetRightViewText
{
    return rightTextLabel.text;
}


@end

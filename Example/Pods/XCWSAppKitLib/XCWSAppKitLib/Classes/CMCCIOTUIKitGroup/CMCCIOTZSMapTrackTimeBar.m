//
//  CMCCIOTZSMapTrackTimeBar.m
//  zongshenMotor
//
//  Created by BigKrist on 16/2/24.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTZSMapTrackTimeBar.h"
#import "CMCCIOTAppKit.h"

@interface CMCCIOTZSMapTrackTimeBar ()
{
    UILabel *timeShownLabel;
    UIButton *nextBtn;
    UIButton *prevBtn;
}
- (void)createCustomView;
- (void)clickNextBtnEvent:(id)sender;
- (void)clickPrevBtnEvent:(id)sender;
- (void)clickTimeBarEvent:(id)sender;
@end

@implementation CMCCIOTZSMapTrackTimeBar

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
    timeShownLabel = [[UILabel alloc] init];
    [self addSubview:timeShownLabel];
    timeShownLabel.keepHeight.equal = 40;
    timeShownLabel.keepWidth.equal = 150;
    timeShownLabel.keepVerticalCenter.equal = 0.5;
    timeShownLabel.keepHorizontalCenter.equal = 0.5;
    timeShownLabel.backgroundColor = [UIColor clearColor];
    timeShownLabel.textAlignment = NSTextAlignmentCenter;
    timeShownLabel.font = [UIFont boldSystemFontOfSize:17];
    timeShownLabel.textColor = [UIColor whiteColor];
    
    nextBtn = [[UIButton alloc] init];
    [self addSubview:nextBtn];
    nextBtn.keepTopInset.equal = 0;
    nextBtn.keepBottomInset.equal = 0;
    nextBtn.keepVerticalCenter.equal = 0.5;
    nextBtn.keepLeftOffsetTo(timeShownLabel).equal = 20;
    nextBtn.keepWidth.equal = 70;
//    [nextBtn setTitle:@">>" forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage imageNamed:@"redRightDoubleArrow"] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickNextBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    prevBtn = [[UIButton alloc] init];
    [self addSubview:prevBtn];
    prevBtn.keepTopInset.equal = 0;
    prevBtn.keepBottomInset.equal = 0;
    prevBtn.keepVerticalCenter.equal = 0.5;
    prevBtn.keepRightOffsetTo(timeShownLabel).equal = 20;
    prevBtn.keepWidth.equal = 70;
//    [prevBtn setTitle:@"<<" forState:UIControlStateNormal];
    [prevBtn setImage:[UIImage imageNamed:@"redLeftArrow"] forState:UIControlStateNormal];
    prevBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [prevBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [prevBtn addTarget:self action:@selector(clickPrevBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *timeBarBtn = [[UIButton alloc] init];
    [self addSubview:timeBarBtn];
    timeBarBtn.keepLeftAlignTo(timeShownLabel).equal = 0;
    timeBarBtn.keepTopAlignTo(timeShownLabel).equal = 0;
    timeBarBtn.keepWidthTo(timeShownLabel).equal = 1;
    timeBarBtn.keepHeightTo(timeShownLabel).equal = 1;
    timeBarBtn.backgroundColor = [UIColor clearColor];
    [timeBarBtn addTarget:self action:@selector(clickTimeBarEvent:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickNextBtnEvent:(id)sender
{
    NSString *nowShownStr = timeShownLabel.text;
    if(nowShownStr == nil || [nowShownStr isStringEmpty])
        return;
    
    nowShownStr = [NSString stringWithFormat:@"%@ 00:00:00",nowShownStr];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSDate *relativeDate = [dateFormatter dateFromString:nowShownStr];
    NSDate *nowDate = [NSDate date];
    if([[relativeDate earlierDate:nowDate] isEqualToDate:nowDate])
        return;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *relativeDateStr = [dateFormatter stringFromDate:relativeDate];
    NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
    if([relativeDateStr isEqualToString:nowDateStr])
        return;
    
    NSDate *newDate = [relativeDate dateByAddingTimeInterval:60*60*24];
    NSString *newShownStr = [dateFormatter stringFromDate:newDate];
    timeShownLabel.text = newShownStr;
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotZSMapTrackTimeBarTimeChanged:)])
        [self.delegate cmcciotZSMapTrackTimeBarTimeChanged:newShownStr];
}

- (void)clickPrevBtnEvent:(id)sender
{
    NSString *nowShownStr = timeShownLabel.text;
    if(nowShownStr == nil || [nowShownStr isStringEmpty])
        return;
    
    nowShownStr = [NSString stringWithFormat:@"%@ 00:00:00",nowShownStr];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSDate *relativeDate = [dateFormatter dateFromString:nowShownStr];
    NSDate *newDate = [relativeDate dateByAddingTimeInterval:60*60*24*(-1)];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *lastDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*(-90)];
    NSString *lastDateStr = [dateFormatter stringFromDate:lastDate];
    NSString *newShownStr = [dateFormatter stringFromDate:newDate];
    if ([lastDateStr isEqualToString:newShownStr]) {
        return;
    }
    timeShownLabel.text = newShownStr;
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotZSMapTrackTimeBarTimeChanged:)])
        [self.delegate cmcciotZSMapTrackTimeBarTimeChanged:newShownStr];
}

- (void)clickTimeBarEvent:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotZSMapTrackTimeBarUserTapped)])
        [self.delegate cmcciotZSMapTrackTimeBarUserTapped];
}

- (void)cmcciotSetShownTimeStr:(NSString *)targetShownTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSDate *relativeDate = [dateFormatter dateFromString:targetShownTime];
    NSDate *nowDate = [NSDate date];
    if([[relativeDate earlierDate:nowDate] isEqualToDate:nowDate])
    {
        return;
    }
    else
    {
        timeShownLabel.text = targetShownTime;
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotZSMapTrackTimeBarTimeChanged:)])
            [self.delegate cmcciotZSMapTrackTimeBarTimeChanged:targetShownTime];
    }
    
}

- (NSString*)cmcciotGetShownTimeStr
{
    NSString *nowStr = timeShownLabel.text;
    return nowStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

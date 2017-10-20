//
//  CMCCIOTTrackTimeBar.m
//  driverGuard
//
//  Created by BigKrist on 16/4/7.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTTrackTimeBar.h"
#import "CMCCIOTAppKit.h"
@interface CMCCIOTTrackTimeBar ()
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

@implementation CMCCIOTTrackTimeBar

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
    timeShownLabel.font = [UIFont systemFontOfSize:15];
    timeShownLabel.textColor = [@"23B7F3" cmcciotHexColor];
    
    nextBtn = [[UIButton alloc] init];
    [self addSubview:nextBtn];
    nextBtn.keepTopInset.equal = 0;
    nextBtn.keepBottomInset.equal = 0;
    nextBtn.keepVerticalCenter.equal = 0.5;
    nextBtn.keepRightInset.equal = 0;
    nextBtn.keepWidth.equal = 70;
    [nextBtn setTitle:@"下一天" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [nextBtn setTitleColor:[BTN_DISABLED_COLOR cmcciotHexColor] forState:UIControlStateDisabled];
    [nextBtn addTarget:self action:@selector(clickNextBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    prevBtn = [[UIButton alloc] init];
    [self addSubview:prevBtn];
    prevBtn.keepTopInset.equal = 0;
    prevBtn.keepBottomInset.equal = 0;
    prevBtn.keepVerticalCenter.equal = 0.5;
    prevBtn.keepLeftInset.equal = 0;
    prevBtn.keepWidth.equal = 70;
    [prevBtn setTitle:@"上一天" forState:UIControlStateNormal];
    prevBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [prevBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [prevBtn setTitleColor:[BTN_DISABLED_COLOR cmcciotHexColor] forState:UIControlStateDisabled];
    [prevBtn addTarget:self action:@selector(clickPrevBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *timeBarBtn = [[UIButton alloc] init];
    [self addSubview:timeBarBtn];
    timeBarBtn.keepLeftAlignTo(timeShownLabel).equal = 0;
    timeBarBtn.keepTopAlignTo(timeShownLabel).equal = 0;
    timeBarBtn.keepWidthTo(timeShownLabel).equal = 1;
    timeBarBtn.keepHeightTo(timeShownLabel).equal = 1;
    timeBarBtn.backgroundColor = [UIColor clearColor];
    [timeBarBtn addTarget:self action:@selector(clickTimeBarEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSDate *nowDate = [NSDate date];
      NSString *relativeDateStr = [dateFormatter stringFromDate:nowDate];
    timeShownLabel.text = relativeDateStr;
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
    if([relativeDateStr isEqualToString:nowDateStr]){
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotMapTrackTimeBarWarning:)])
            [self.delegate cmcciotMapTrackTimeBarWarning:@"查询日期不能超出当前日期"];
        return;
    }
    
    NSDate *newDate = [relativeDate dateByAddingTimeInterval:60*60*24];
    NSString *newShownStr = [dateFormatter stringFromDate:newDate];
    timeShownLabel.text = newShownStr;
    
    //如果当前显示的时候是今天，则按钮下一天 置灰
    if ([newShownStr isEqualToString:nowDateStr]) {
        nextBtn.enabled = NO;
    } else {
        nextBtn.enabled = YES;
    }
    
    //如果当前显示的时候是前90天，则按钮上一天 置灰
    NSDate *pastPrevPointDate = [nowDate dateByAddingTimeInterval:60*60*24*90*(-1)];
    NSString *pastPrevPointDateStr = [dateFormatter stringFromDate:pastPrevPointDate];
    if ([newShownStr isEqualToString:pastPrevPointDateStr]) {
        prevBtn.enabled = NO;
    } else {
        prevBtn.enabled = YES;
    }
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotMapTrackTimeBarTimeChanged:)])
        [self.delegate cmcciotMapTrackTimeBarTimeChanged:newShownStr];
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
    NSDate *nowDate = [NSDate date];
    NSDate *pastPointDate = [nowDate dateByAddingTimeInterval:60*60*24*91*(-1)];
    NSDate *newDate = [relativeDate dateByAddingTimeInterval:60*60*24*(-1)];
    if([[newDate earlierDate:pastPointDate] isEqualToDate:newDate])
    {
        //超过90天以前的信息不能显示
        return;
    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newShownStr = [dateFormatter stringFromDate:newDate];
    timeShownLabel.text = newShownStr;
    
    //如果当前显示的时候是今天，则按钮下一天 置灰
    NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
    if ([newShownStr isEqualToString:nowDateStr]) {
        nextBtn.enabled = NO;
    } else {
        nextBtn.enabled = YES;
    }
    
    //如果当前显示的时候是前90天，则按钮上一天 置灰
    NSDate *pastPrevPointDate = [nowDate dateByAddingTimeInterval:60*60*24*90*(-1)];
    NSString *pastPrevPointDateStr = [dateFormatter stringFromDate:pastPrevPointDate];
    if ([newShownStr isEqualToString:pastPrevPointDateStr]) {
        prevBtn.enabled = NO;
    } else {
        prevBtn.enabled = YES;
    }
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotMapTrackTimeBarTimeChanged:)])
        [self.delegate cmcciotMapTrackTimeBarTimeChanged:newShownStr];
}

- (void)clickTimeBarEvent:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotMapTrackTimeBarUserTapped)])
        [self.delegate cmcciotMapTrackTimeBarUserTapped];
}


- (void)cmcciotSetShownTimeStr:(NSString *)targetShownTime
{
    targetShownTime = [NSString stringWithFormat:@"%@ 00:00:00",targetShownTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSDate *relativeDate = [dateFormatter dateFromString:targetShownTime];
    NSDate *nowDate = [NSDate date];
    NSDate *pastPointDate = [nowDate dateByAddingTimeInterval:60*60*24*91*(-1)];
    NSDate *earlierDate = [relativeDate earlierDate:nowDate];
    if([earlierDate isEqualToDate:nowDate])
    {
        return;
    }
    else if([[relativeDate earlierDate:pastPointDate] isEqualToDate:relativeDate])
    {
        //90天以前的信息不能显示
        return;
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *targetShownTime = [dateFormatter stringFromDate:relativeDate];
        
        timeShownLabel.text = targetShownTime;
        
        //如果当前显示的时候是今天，则按钮下一天 置灰
        NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
        if ([targetShownTime isEqualToString:nowDateStr]) {
            nextBtn.enabled = NO;
        } else {
            nextBtn.enabled = YES;
        }
        
        //如果当前显示的时候是前90天，则按钮上一天 置灰
        NSDate *pastPrevPointDate = [nowDate dateByAddingTimeInterval:60*60*24*90*(-1)];
        NSString *pastPrevPointDateStr = [dateFormatter stringFromDate:pastPrevPointDate];
        if ([targetShownTime isEqualToString:pastPrevPointDateStr]) {
            prevBtn.enabled = NO;
        } else {
            prevBtn.enabled = YES;
        }
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotMapTrackTimeBarTimeChanged:)])
            [self.delegate cmcciotMapTrackTimeBarTimeChanged:targetShownTime];
    }
    
}

- (NSString*)cmcciotGetShownTimeStr
{
    NSString *nowStr = timeShownLabel.text;
    return nowStr;
}

@end

//
//  CMCCIOTZSDatePickerContainer.m
//  zongshenMotor
//
//  Created by BigKrist on 16/2/25.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTZSDatePickerContainer.h"
#import "CMCCIOTAppKit.h"

@interface CMCCIOTZSDatePickerContainer ()
{
    UILabel *titleLabel;
    UIDatePicker *datePicker;
}
- (void)createCustomView;
- (void)clickCancelEvent:(id)sender;
- (void)clickSureEvent:(id)sender;
- (void)datePickerHasChangedValue:(id)sender;
@end

@implementation CMCCIOTZSDatePickerContainer


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self createCustomView];
    }
    return self;
}

- (void)createCustomView
{
    UIButton *cancelBtn = [[UIButton alloc] init];
    [self addSubview:cancelBtn];
    cancelBtn.keepTopInset.equal = 0;
    cancelBtn.keepLeftInset.equal = 0;
    cancelBtn.keepHeight.equal = 45;
    cancelBtn.keepWidth.equal = 75;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(clickCancelEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [self addSubview:sureBtn];
    sureBtn.keepTopInset.equal = 0;
    sureBtn.keepRightInset.equal = 0;
    sureBtn.keepHeight.equal = 45;
    sureBtn.keepWidth.equal = 75;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureBtn addTarget:self action:@selector(clickSureEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    titleLabel.keepLeftOffsetTo(cancelBtn).equal = 0;
    titleLabel.keepRightOffsetTo(sureBtn).equal = 0;
    titleLabel.keepTopInset.equal = 0;
    titleLabel.keepHeight.equal = 45;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"请选择时间";
    
    datePicker = [[UIDatePicker alloc] init];
    [self addSubview:datePicker];
    datePicker.keepLeftInset.equal = 0;
    datePicker.keepRightInset.equal = 0;
    datePicker.keepHorizontalCenter.equal = 0.5;
    datePicker.keepTopOffsetTo(titleLabel).equal = 0;
    datePicker.keepBottomInset.equal = 0;
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker addTarget:self action:@selector(datePickerHasChangedValue:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)datePickerHasChangedValue:(id)sender
{
    
}

- (void)clickCancelEvent:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotUserCanclePicker:)])
        [self.delegate cmcciotUserCanclePicker:self];
}

- (void)clickSureEvent:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cmcciotUserSubmitTime:contextInfo:pickerContainer:)])
    {
        [self.delegate cmcciotUserSubmitTime:datePicker.date contextInfo:self.contextInfo pickerContainer:self];
    }
}

- (void)cmcciotSetPickMaxDate:(NSDate *)maxDate minDate:(NSDate *)minDate
{
    
    if([[maxDate earlierDate:minDate] isEqualToDate:maxDate])
        return;
    
//    if([maxDate isEqualToDate:minDate])
//        return;
    
    if(maxDate != nil)
        datePicker.maximumDate = maxDate;
    
    if(minDate != nil)
        datePicker.minimumDate = minDate;
    
}

- (void)cmcciotSetPickerMode:(UIDatePickerMode)targetMode
{
    datePicker.datePickerMode = targetMode;
}

- (void)cmcciotSetPickerDate:(NSDate *)targetDate
{
    if(targetDate == nil) return;
    [datePicker setDate:targetDate animated:NO];
}

@end

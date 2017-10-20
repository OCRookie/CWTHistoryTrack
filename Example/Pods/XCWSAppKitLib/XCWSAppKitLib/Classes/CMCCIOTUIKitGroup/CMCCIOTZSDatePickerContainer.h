//
//  CMCCIOTZSDatePickerContainer.h
//  zongshenMotor
//  宗申用的时间选择器
//  Created by BigKrist on 16/2/25.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMCCIOTZSDatePickerContainer;

@protocol CMCCIOTZSDatePickerContainerDelegate <NSObject>
- (void)cmcciotUserCanclePicker:(CMCCIOTZSDatePickerContainer*)targetPicker;
- (void)cmcciotUserSubmitTime:(NSDate*)timer contextInfo:(id)contextInfo pickerContainer:(CMCCIOTZSDatePickerContainer*)targetPicke;
@end

@interface CMCCIOTZSDatePickerContainer : UIView
@property (nonatomic,weak) id<CMCCIOTZSDatePickerContainerDelegate> delegate;
@property (nonatomic,weak) id contextInfo;
- (void)cmcciotSetPickMaxDate:(NSDate *)maxDate minDate:(NSDate *)minDate;
- (void)cmcciotSetPickerMode:(UIDatePickerMode)targetMode;
- (void)cmcciotSetPickerDate:(NSDate*)targetDate;
@end

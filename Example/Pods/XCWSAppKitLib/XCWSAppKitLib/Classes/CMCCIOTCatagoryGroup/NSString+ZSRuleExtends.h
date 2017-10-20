//
//  NSString+ZSRuleExtends.h
//  zongshenMotor
//
//  Created by gaomaolin on 16/2/15.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZSRuleExtends)
- (BOOL)cmcciotValidScanBatteryCode;

//验证用户昵称是否符合规则
- (BOOL)cmcciotValidZSUserNickName;

//验证验证码是否符合规则
- (BOOL)cmcciotValidVerifyCode;

//验证是否有效的设备序列号
- (BOOL)cmcciotValidDeviceNum;

//验证是否有效的车辆Vin号
- (BOOL)cmcciotValidMotorVin;

//验证是否合理的密码
- (BOOL)cmcciotValidZSPsw;
@end

//
//  CMCCIOTZSTypeInputFiled.h
//  zongshenMotor
//  宗申风格的输入框
//  Created by BigKrist on 16/2/14.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCCIOTTextFiled.h"

@interface CMCCIOTZSTypeInputFiled : UIView

/*自定义的删除按钮*/
@property(nonatomic,strong)UIButton *rightView;

- (void)cmcciotZSTypeSetTheMaxLength:(NSInteger)targetMaxLength;
- (NSString*)cmcciotGetZSTypeTFString;
- (void)cmcciotZSSetInputPlaceHolder:(NSString*)targetPlaceHolder;
- (void)cmcciptZSSetInputString:(NSString*)targetString;
- (void)cmcciotZSResignFirstResponder;
- (void)cmcciotZSBecomeFirstResponder;
- (CMCCIOTTextFiled*)cmcciotZSTextField;
@end

//
//  CMCCIOTZSTypeInputFiled.m
//  zongshenMotor
//
//  Created by BigKrist on 16/2/14.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTZSTypeInputFiled.h"
#import "CMCCIOTAppKit.h"

@interface CMCCIOTZSTypeInputFiled ()
{
    CMCCIOTTextFiled *innerTextField;
}

@end

@implementation CMCCIOTZSTypeInputFiled


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [COLOR_NAVI_BG cmcciotHexColor];
        innerTextField = [[CMCCIOTTextFiled alloc] init];
        [self addSubview:innerTextField];
        innerTextField.keepHeight.equal = 17;
        innerTextField.keepVerticalCenter.equal = 0.5;
        innerTextField.keepHorizontalCenter.equal = 0.5;
        innerTextField.textColor = [UIColor
                                    whiteColor];
        innerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        /*
        UIButton *rightView = [[UIButton alloc] init];
        [rightView setImage:[UIImage imageNamed:@"UITextFieldRightView"] forState:UIControlStateNormal];
        [self setRightView:rightView];
        */
    }
    return self;
}

#pragma mark -
#pragma mark Property set
- (void)setRightView:(UIButton *)rightView{
    
    innerTextField.clearButtonMode = UITextFieldViewModeNever;
    _rightView = rightView;
    [_rightView addTarget:self action:@selector(touch_rightView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_rightView];
    _rightView.keepVerticalCenter.equal = 0.5;
    _rightView.keepRightInset.equal = 0;
    _rightView.keepWidth.equal = 30;
    _rightView.keepHeight.equal = 30;
}

- (void)touch_rightView:(UIButton *)rightView{
    innerTextField.text = @"";
}

#pragma mark -
#pragma mark - Public Methods
- (void)cmcciotZSTypeSetTheMaxLength:(NSInteger)targetMaxLength
{
    if(innerTextField == nil) return;
    if(targetMaxLength < 0)
    {
        innerTextField.cmcciotMaxLength = 0;
        return;
    }
    
    innerTextField.cmcciotMaxLength = targetMaxLength;
}

- (NSString*)cmcciotGetZSTypeTFString
{
    if(innerTextField == nil) return @"";
    return innerTextField.text;
}

- (void)cmcciotZSSetInputPlaceHolder:(NSString *)targetPlaceHolder
{
    if(targetPlaceHolder == nil) return;
    innerTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:targetPlaceHolder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[@"999999" cmcciotHexColor]/*,NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:-2]*/}];
}

- (void)cmcciptZSSetInputString:(NSString *)targetString
{
    if(innerTextField == nil) return;
    innerTextField.text = targetString;
}

- (void)cmcciotZSResignFirstResponder
{
    if(innerTextField == nil) return;
    [innerTextField resignFirstResponder];
}

- (void)cmcciotZSBecomeFirstResponder
{
    if(innerTextField == nil) return;
    [innerTextField becomeFirstResponder];
}

- (CMCCIOTTextFiled*)cmcciotZSTextField
{
    return innerTextField;
}

- (void)layoutSubviews
{
    [innerTextField.keepLeftInset deactivate];
    [innerTextField.keepRightInset deactivate];
    if(self.frame.size.width < 30)
    {
        innerTextField.keepLeftInset.equal = 0;
        innerTextField.keepRightInset.equal = 0;
    }
    else
    {
        innerTextField.keepLeftInset.equal = 15;
        innerTextField.keepRightInset.equal = 15;
    }
    [super layoutSubviews];
}

@end

//
//  CMCCIOTTextView.m
//  LuShang
//
//  Created by BigKrist on 15/11/18.
//  Copyright © 2015年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTTextView.h"

@interface CMCCIOTTextView ()
- (void)cmcciotExtendsInit;
- (void)cmcciotHandleTextDidChangeEventNoti:(NSNotification*)targetNoti;
@end

@implementation CMCCIOTTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self cmcciotExtendsInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self cmcciotExtendsInit];
    }
    return self;
}

- (void)cmcciotExtendsInit
{
    _cmcciotMaxLength = 10000000;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cmcciotHandleTextDidChangeEventNoti:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)cmcciotHandleTextDidChangeEventNoti:(NSNotification *)targetNoti
{
    UITextView *textView = (UITextView *)targetNoti.object;
    
    NSString *toBeString = textView.text;
    NSString *lang = [textView.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _cmcciotMaxLength) {
                textView.text = [toBeString substringToIndex:_cmcciotMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > _cmcciotMaxLength) {
            textView.text = [toBeString substringToIndex:_cmcciotMaxLength];
        }
    }
}

@end

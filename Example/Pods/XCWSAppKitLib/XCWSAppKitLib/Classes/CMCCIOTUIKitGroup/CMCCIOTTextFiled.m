//
//  CMCCIOTTextFiled.m
//  LuShang
//
//  Created by BigKrist on 15/11/17.
//  Copyright © 2015年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTTextFiled.h"

@interface CMCCIOTTextFiled ()
- (void)cmcciotExtendsInit;
- (void)cmcciotHandleTextDidChangeEventNoti:(NSNotification*)targetNoti;
@end

@implementation CMCCIOTTextFiled

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (NSArray*)cmcciotCreatePasswordSet
{
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"_"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (instancetype)init
//{
//    self = [super init];
//    if(self)
//    {
//        [self cmcciotExtendsInit];
//    }
//    return self;
//}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cmcciotHandleTextDidChangeEventNoti:) name:UITextFieldTextDidChangeNotification object:self];
}

- (void)cmcciotHandleTextDidChangeEventNoti:(NSNotification *)targetNoti
{
    UITextField *textField = (UITextField *)targetNoti.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _cmcciotMaxLength) {
                textField.text = [toBeString substringToIndex:_cmcciotMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > _cmcciotMaxLength) {
            textField.text = [toBeString substringToIndex:_cmcciotMaxLength];
        }
    }
}


@end

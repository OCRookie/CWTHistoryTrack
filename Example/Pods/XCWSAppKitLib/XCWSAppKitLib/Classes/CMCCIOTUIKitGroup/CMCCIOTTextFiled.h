//
//  CMCCIOTTextFiled.h
//  LuShang
//  添加长度限制了的UITextFiled
//  Created by BigKrist on 15/11/17.
//  Copyright © 2015年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMCCIOTTextFiled : UITextField
@property (nonatomic,assign) NSInteger cmcciotMaxLength;
+ (NSArray*)cmcciotCreatePasswordSet;
@end

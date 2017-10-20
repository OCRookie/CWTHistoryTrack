//
//  CMCCIOTShowMessageContainerView.h
//  CMCCIOTAppKit
//  加载，消息，错误提示弹层信息
//  Created by BigKrist on 15/4/21.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMCCIOTShowMessageContainerViewDelegate <NSObject>
- (void)cmcciotDriftContainerViewHasBeenHidden;
@end

@interface CMCCIOTShowMessageContainerView : UIView
@property (nonatomic,weak) id<CMCCIOTShowMessageContainerViewDelegate> cmcciotDelegate;
/**
 *  弹出信息提示
 *
 *  @param messageToShown 要显示的信息
 */
- (void)cmcciotShowMessage:(NSString*)messageToShown;

/**
 *  弹出错误信息提示
 *
 *  @param errorToShown 要显示的错误信息
 */
- (void)cmcciotShowError:(NSString*)errorToShown;

/**
 *  弹出加载信息提示框
 *
 *  @param loadingInfo 要显示的加载信息
 */
- (void)cmcciotStartLoadingWith:(NSString*)loadingInfo;

/**
 *  停止加载信息的提示
 */
- (void)cmcciotStopLoading;
@end

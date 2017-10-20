//
//  CMCCIOTUIKitBaseViewController.h
//  CMCCIOTAppKit
//  基准BaseViewController , 定义一些基础方法在上面
//  Created by BigKrist on 15/4/21.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCCIOTNavigationController.h"
#import "CMCCIOTShowMessageContainerView.h"

@interface CMCCIOTUIKitBaseViewController : UIViewController<CMCCIOTNavigationControllerDelegate,CMCCIOTShowMessageContainerViewDelegate>
@property (strong, nonatomic) UIColor *cmcciotBarButtonItemColor;
@property (nonatomic, readonly) CGFloat contentHeight;
@property (nonatomic, readonly) CGFloat contentWidth;


/**
 *  生成CMCCIOTNavigationController类型的NavigationController
 *
 *  @return CMCCIOTNavigationController的实例子，并且自己类型的那个实例为root vc
 */
+ (UINavigationController*)cmcciotCreateBaseNavigationController;



- (void)cmcciotSetTitleView:(UIView *)view;


/**
 *  设置顶部左按钮功能
 *
 *  @param leftBarItemTitle 顶部左按钮要显示的字
 */
- (void)cmcciotSetLeftBarItemWithTitle:(NSString *)leftBarItemTitle;

/**
 *  设置顶部右按钮功能
 *
 *  @param rightBarItemTitle 顶部右按钮要显示的字
 */
- (void)cmcciotSetRightBarItemWithTitle:(NSString *)rightBarItemTitle;


/**
 *  设置顶部左按钮字描述和颜色功能
 *
 *  @param leftBarItemTitle 顶部左按钮要显示的字
 *  @param color            顶部左按钮的颜色
 */
- (void)cmcciotSetLeftBarItemWithTitle:(NSString *)leftBarItemTitle Color:(UIColor *)color;

/**
 *  设置顶部右按钮字描述和颜色功能
 *
 *  @param rightBarItemTitle 顶部右按钮要显示的字
 *  @param color             顶部右按钮的颜色
 */
- (void)cmcciotSetRightBarItemWithTitle:(NSString *)rightBarItemTitle Color:(UIColor *)color;


/**
 *  设置顶部左按钮的标题颜色
 *
 *  @param color 顶部左按钮标题颜色
 */
- (void)cmcciotSetLeftBarItemTitleColor:(UIColor *)color;


/**
 *  设置顶部右按钮的字体颜色
 *
 *  @param color 顶部右按钮标题颜色
 */
- (void)cmcciotSetRightBarItemWithTitleColor:(UIColor *)color;


/**
 *  设置顶部左按钮的图片
 *
 *  @param image 顶部左按钮的图片
 */
- (void)cmcciotSetLeftBarItemWithImage:(UIImage *)image;


/**
 *  设置顶部右按钮的图片
 *
 *  @param image 顶部右按钮的图片
 */
- (void)cmcciotSetRightBarItemWithImage:(UIImage *)image;


///**
// *  设置顶部左边按钮View
// *
// *  @param view 顶部左边按钮View
// */
//- (void)cmcciotSetLeftBarItemWithView:(UIView *)view;
//
//
///**
// *  设置顶部右边按钮View
// *
// *  @param view 顶部右边按钮View
// */
//- (void)cmcciotSetRightBarItemWithView:(UIView *)view;


/**
 *  返回顶部左边按钮实例
 *
 *  @return 顶部左边按钮实例
 */
- (UIBarButtonItem *)cmcciotLeftBarItem;


/**
 *  返回顶部右边按钮实例
 *
 *  @return 顶部右边按钮实例
 */
- (UIBarButtonItem *)cmcciotRightBarItem;


/**
 *  顶部左边按钮点击方法
 *
 *  @param sender 顶部左边按钮实例
 */
- (void)cmcciotDidClickLeftBtnEvent:(id)sender;


/**
 *  顶部右边按钮点击方法
 *
 *  @param sender 顶部右边按钮实例
 */
- (void)cmcciotDidClickRightBtnEvent:(id)sender;


/**
 *  显示信息方法
 *
 *  @param showInfo 要现实的信息
 */
- (void)cmcciotShowMessageInfo:(NSString*)showInfo;

/**
 *  显示错误信息方法
 *
 *  @param errorMessage 要显示的错误信息
 */
- (void)cmcciotShowErrorMessage:(NSString*)errorMessage;
//- (void)showErrorDicMessage:(NSDictionary*)errorDicInfo;

/**
 *  弹出loading框
 *
 *  @param loadingTitle loading框上面显示的文字
 */
- (void)cmcciotStartLoadingWith:(NSString*)loadingTitle;


/**
 *  停止loading框
 */
- (void)cmcciotStopLoading;
@end

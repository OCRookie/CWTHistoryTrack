//
//  CMCCIOTNavigationController.h
//  CMCCIOTAppKit
//  支持手势返回的NavigationController
//  Created by BigKrist on 15/4/21.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMCCIOTNavigationController;

@protocol CMCCIOTNavigationControllerDelegate <NSObject>
@optional
/**
 *  子类可以实现这个协议，用于控制是否禁止手势返回
 *
 *  @param navigationController 目标navigationController控件
 *
 *  @return YES表示可以被手势返回，NO表示不能被手势返回
 */
- (BOOL)cmcciotNavigationControllerCanBeMoved:(CMCCIOTNavigationController*)navigationController;

/**
 *  子类实现这个函数之后，每当手势即将返回时，这个函数将会被触发，以便于ViewController在被推出前进行一些资源清理工作
 */
- (void)cmcciotNavigationWillBePopedOut;
@end

@interface CMCCIOTNavigationController : UINavigationController<UIGestureRecognizerDelegate>
@property (nonatomic,weak) id<CMCCIOTNavigationControllerDelegate> cmcciotNaviDelegate;
@end

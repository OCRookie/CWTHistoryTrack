//
//  CMCCIOTAppKit.h
//  CMCCIOTAppKit
//  公共导出头
//  Created by BigKrist on 15/4/20.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for CMCCIOTAppKit.
FOUNDATION_EXPORT double CMCCIOTAppKitVersionNumber;

//! Project version string for CMCCIOTAppKit.
FOUNDATION_EXPORT const unsigned char CMCCIOTAppKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CMCCIOTAppKit/PublicHeader.h>

#define gMainQueueT dispatch_get_main_queue()
#define gAsynQueueT dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#if 1
#define CMCCIOTLOG(fmt, ...) do { \
NSString* file = [[NSString alloc] initWithFormat:@"%s", __FILE__]; \
NSLog((@"%@ | %d | %s | " fmt), [file lastPathComponent], __LINE__,__func__, ##__VA_ARGS__); \
} while(0)
#else
#define CMCCIOTLOG(fmt, ...) {}
#endif

#define gNoti_AppTokenWasExpierNoti @"gNoti_AppTokenWasExpierNoti"    //token过期通知
#define  gNoti_APPLoginInAfter @"gNoti_APPLoginInAfter" //登陆成功之后的通知
#define gNoti_AppNeedRefreshData @"gNoti_AppNeedRefreshData"    //通知全局刷新数据，一般用于登录成功之后的处理
#define gNoti_AppReceivedPushNoti @"gNoti_AppReceivedPushNoti"   //用户收到推送

#define gConfigFile @"globalConfigFile"                     //全局配置文件名
#define gKUserName @"gUserName"      //用户名键位
#define gKUserPsw  @"gUserPassword"  //用户密码


#define COLOR_COMMON_BG             @"2b3446"
#define COLOR_NAVI_BG               @"323c52"
#define COLOR_BLUE_BOARDER          @"00a1ea"

#define COLOR_COMMON_LINE       @"415159"
#define COLOR_COMMON_BLUE       @"23b7f3"
#define COLOR_GRAY_TEXT         @"8d8d8d"


#pragma mark - 
#pragma mark FundationCategory export
#import "CMCCIOTAppKitDelegate.h"
#import "NSString+CMCCIOTFundationCategory.h"
#import "NSDate+CMCCIOTFundationCategory.h"
#import "UIImage+fixOrientation.h"
#import "UIView+CMCCIOTFundationCategory.h"
#import "NSObject+CMCCIOTAssertTypeCategory.h"
#import "NSURL+CMCCIOTFundationCategory.h"
#import "NSString+CommonExtends.h"
#import "NSString+ColorCategory.h"
#import "NSString+ZSRuleExtends.h"
#import "UIImage+Oxygen.h"
#import "UIViewAdditions.h"
#import "NSObject+StringTypeCate.h"

#pragma mark -
#pragma mark - CMCCIOTUIKit export
#import "CMCCIOTNavigationController.h"
#import "CMCCIOTShowMessageContainerView.h"
#import "CMCCIOTUIKitBaseViewController.h"
#import "CMCCIOTDGBaseViewController.h"


#pragma mark - 
#pragma mark -  CMCCIOTDeviceKit export


#pragma mark -
#pragma mark - CMCCIOTNetKit export
#import "CMCCIOTNetKit.h"


#pragma mark  -
#pragma mark CMCCIOTFileManagerGroup export
#import "CMCCIOTFileManager.h"

#pragma mark -
#pragma mark CMCCIOTConfigHelper export
#import "CMCCIOTConfigHelper.h"

#pragma mark -
#pragma mark CMCCIOTEncryptionGroup export
#import "CMCCIOTEncryption.h"


#pragma mark -
#pragma mark ThirdPartLibs export
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "KeepLayout.h"
#import "KeepLayoutConstraint.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "BlocksKit+MessageUI.h"


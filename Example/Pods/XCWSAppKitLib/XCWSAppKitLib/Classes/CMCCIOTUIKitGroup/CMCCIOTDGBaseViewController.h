//
//  CMCCIOTDGBaseViewController.h
//  driverGuard
//  行车卫士2.0的基础VC类，后续一般情况下ViewController应该继承自这个VC
//  Created by BigKrist on 16/3/21.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTAppKit.h"


typedef void (^ClickSureBlock)();
@interface CMCCIOTDGBaseViewController : CMCCIOTUIKitBaseViewController
{
    UIView *horizonRelativeLine;
    UIView *verticalRelativeLine;
    
    //给自定义的navibar提供资源
    UIView *innerTopNaviBar;
    UIButton *innerTopLeftBtn;
    UILabel *innerTopNaviTitleLabel;
}

- (void)cmcciotShowTip:(NSString*)targetTip imageName:(NSString*)imageName btnDes:(NSString*)btnDes allowAutoHide:(BOOL)autoHideTag clickSureBlock:(ClickSureBlock)targetSureBlock;
- (void)clickTipSureBtnEvent:(id)sender;
- (void)createCustomTopBar;
- (void)cmcciotSetCustomTitle:(NSString*)targetTitleStr;
@end

//
//  CMCCIOTZSSelectTrackTimeBtn.h
//  zongshenMotor
//  定制的在宗申中选择时间的按钮
//  Created by BigKrist on 16/2/24.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMCCIOTZSSelectTrackTimeBtn : UIButton
- (void)cmcciotZSSetLeftViewColor:(UIColor*)targetColor;
- (void)cmcciotZSSetLeftViewText:(NSString*)targetText;
- (void)cmcciotZSSetRightViewText:(NSString*)targetText;
- (NSString*)cmcciotZSGetRightViewText;
@end

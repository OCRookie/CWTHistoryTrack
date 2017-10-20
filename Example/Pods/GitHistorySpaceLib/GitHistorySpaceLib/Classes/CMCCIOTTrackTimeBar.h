//
//  CMCCIOTTrackTimeBar.h
//  driverGuard
//  轨迹页面顶部选择时间的时间条
//  Created by BigKrist on 16/4/7.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CMCCIOTMapTrackTimeBarDelegate <NSObject>
- (void)cmcciotMapTrackTimeBarTimeChanged:(NSString*)targetNewTimeStr;
- (void)cmcciotMapTrackTimeBarUserTapped;
- (void)cmcciotMapTrackTimeBarWarning:(NSString *)warning;
@end

@interface CMCCIOTTrackTimeBar : UIView
@property (nonatomic,weak) id<CMCCIOTMapTrackTimeBarDelegate> delegate;
- (void)cmcciotSetShownTimeStr:(NSString*)targetShownTime;
- (NSString*)cmcciotGetShownTimeStr;
@end

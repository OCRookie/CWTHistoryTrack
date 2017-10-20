//
//  CMCCIOTZSMapTrackTimeBar.h
//  zongshenMotor
//  查询轨迹中的时间条
//  Created by BigKrist on 16/2/24.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMCCIOTZSMapTrackTimeBarDelegate <NSObject>
- (void)cmcciotZSMapTrackTimeBarTimeChanged:(NSString*)targetNewTimeStr;
- (void)cmcciotZSMapTrackTimeBarUserTapped;
@end

@interface CMCCIOTZSMapTrackTimeBar : UIView
@property (nonatomic,weak) id<CMCCIOTZSMapTrackTimeBarDelegate> delegate;
- (void)cmcciotSetShownTimeStr:(NSString*)targetShownTime;
- (NSString*)cmcciotGetShownTimeStr;
@end

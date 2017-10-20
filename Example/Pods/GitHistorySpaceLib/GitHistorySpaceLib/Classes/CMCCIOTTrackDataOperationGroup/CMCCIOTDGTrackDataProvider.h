//
//  CMCCIOTDGTrackDataProvider.h
//  driverGuard
//  获取轨迹的数据操作类
//  Created by BigKrist on 16/4/8.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMCCIOTDGTrackDataProviderDelegate <NSObject>
- (void)cmcciotDGGetTrackFailedWith:(NSError*)error;
- (void)cmcciotDGGetTrackSuccessWith:(NSArray*)retArray;
@end

@interface CMCCIOTDGTrackDataProvider : NSObject
@property (nonatomic,weak) id<CMCCIOTDGTrackDataProviderDelegate> delegate;
- (void)cmcciotGetTrackWith:(NSString*)userId deviceId:(NSString*)targetDeviceId trackBeginTime:(NSString*)trackBeginTime trackEndTime:(NSString*)trackEndTime;
@end

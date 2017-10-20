//
//  CMCCIOTDeviceStateAnnotation.h
//  driverGuard
//
//  Created by BigKrist on 16/4/11.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>

typedef NS_ENUM(NSInteger,CMCCIOTDeviceTrackState){
    CMCCIOTDeviceTrackState_StandStill,
    CMCCIOTDeviceTrackState_Moving,
    CMCCIOTDeviceTrackState_BeginPoint,
    CMCCIOTDeviceTrackState_EndPoint
};

@interface CMCCIOTDeviceStateAnnotation : NSObject<BMKAnnotation>
@property (nonatomic,strong) id contextInfo;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,assign) CMCCIOTDeviceTrackState annotationState;
@end

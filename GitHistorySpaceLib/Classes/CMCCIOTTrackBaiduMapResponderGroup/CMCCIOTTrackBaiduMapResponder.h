//
//  CMCCIOTTrackBaiduMapResponder.h
//  driverGuard
//
//  Created by BigKrist on 16/4/11.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface CMCCIOTTrackBaiduMapResponder : NSObject<BMKMapViewDelegate>
@property (nonatomic,weak) BMKMapView *weakMapView;
- (void)cmcciotClearAnnotaionAndOverlay;
- (void)cmcciotAddTracks:(NSArray*)trackPoints;
- (NSArray*)cmcciotGetInnerTrackArray;
- (void)cmcciotSetTheMovingPointDic:(NSDictionary*)targetPointDicInfo;
@end

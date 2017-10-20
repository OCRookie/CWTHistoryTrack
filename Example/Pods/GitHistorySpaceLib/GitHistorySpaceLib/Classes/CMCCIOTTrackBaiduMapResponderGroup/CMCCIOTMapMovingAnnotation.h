//
//  CMCCIOTMapMovingAnnotation.h
//  driverGuard
//  运行中的轨迹点
//  Created by BigKrist on 16/4/11.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface CMCCIOTMapMovingAnnotation : NSObject<BMKAnnotation>
@property (nonatomic,strong) id contextInfo;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@end
